const cds = require("@sap/cds");
// Relative path to root folder
const rel_path = '/../..';
const basePath = '/odata/v4/assets/Assets';
const { GET, POST, PATCH, DELETE, expect } = cds.test('serve','srv/assets-service.cds').in(__dirname+rel_path)
// const { GET, POST, PATCH, DELETE, expect } = cds.test('serve',
//                                                       "AssetsService",
//                                                       "--from",
//                                                       "schema").in(__dirname+rel_path);

describe('AssetsService', () => {
  let warehouseLocation, retiredAsset, availableAsset;
  let AssetsService, Assets, cats; // Service and entity references

  beforeAll(async () => {
    await cds.deploy(__dirname + rel_path + '/db/schema').to('sqlite::memory:');
    await cds.serve('AssetsService').from(__dirname + rel_path + '/srv/assets-service');

    // Get service and entity references
    AssetsService = cds.services.AssetsService;
    expect(AssetsService).not.to.be.undefined;
    
    Assets = AssetsService.entities.Assets;
    expect(Assets).not.to.be.undefined;

    // Connect to the service
    cats = await cds.connect.to("AssetsService");

    // Use existing data from CSV files
    // Warehouse A location from CSV
    warehouseLocation = await cds.read('com.kartun.movie_studio.Location').where({ name: 'Warehouse A' });
    
    // Find a RETIRED asset from CSV
    retiredAsset = await cds.read('com.kartun.movie_studio.Asset').where({ status_code: 'RETIRED' });
    
    // Find an AVAILABLE asset from CSV
    availableAsset = await cds.read('com.kartun.movie_studio.Asset').where({ status_code: 'AVAILABLE' });
  });

  // --- Rule 1: RETIRED assets cannot be modified ---
  describe('RETIRED assets cannot be modified', () => {
    it('should forbid PATCH on RETIRED assets using service API', async () => {
      try {
        await cats.tx({ user: 'test' }, async tx => {
          await tx.update(Assets).set({ name: 'Modified Name' }).where({ ID: retiredAsset[0].ID });
        });
    
        expect.fail('Should have thrown an error');
      } catch (error) {
        console.log('Caught error:', error.message);
        expect(error.message).to.include('RETIRED assets cannot be modified');
      }
    });
    
    

    it('should forbid DELETE on RETIRED assets using service API', async () => {
      try {
        await cats.tx({ user: "test" }, () => {
          return cats.delete(Assets, retiredAsset[0].ID);
        });
        expect.fail('Should have thrown an error');
      } catch (error) {
        expect(error.message).to.include('RETIRED assets cannot be modified');
      }
    });

    it('should forbid UPDATE on RETIRED assets using HTTP', async () => {
      const response = await PATCH(`${basePath}('${retiredAsset[0].ID}')`, { name: 'Modified Name' });
      expect(response.status).toBe(403);
    });
  });

  // --- Rule 2: Status transition rules ---
  describe('Status transitions', () => {
    it('should clear movie_ID when setting AVAILABLE using service API', async () => {
      const result = await cats.tx({ user: "test" }, () => {
        return cats.update(Assets, availableAsset[0].ID, { 
          status: { code: 'AVAILABLE' },
          movie: { ID: 'MOVIE_123' } // Should be ignored/cleared
        });
      });
      expect(result.movie).to.be.null;
    });

    it('should clear movie_ID when setting AVAILABLE using HTTP', async () => {
      const { status, data } = await PATCH(`${basePath}/Assets('${availableAsset[0].ID}')`, { 
        status: { code: 'AVAILABLE' },
        movie: { ID: 'MOVIE_123' } // Should be ignored/cleared
      });
      expect(status).toBe(200);
      expect(data.movie).toBeNull();
    });

    it('should forbid AVAILABLE with movie_ID using HTTP', async () => {
      const response = await POST('${basePath}', {
        name: 'New Asset',
        status: { code: 'AVAILABLE' },
        movie: { ID: 'MOVIE_123' }, // Invalid combination
        location: { ID: warehouseLocation[0].ID },
        type: { code: 'CAMERA' }
      });
      expect(response.status).toBe(400);
    });

    it('should require movie_ID for RESERVED using service API', async () => {
      try {
        await cats.tx({ user: "test" }, () => {
          return cats.update(Assets, availableAsset[0].ID, {
            status: { code: 'RESERVED' } // Missing movie_ID
          });
        });
        expect.fail('Should have thrown an error');
      } catch (error) {
        expect(error.message).to.include('RESERVED status requires a movie_ID');
      }
    });

    it('should accept RESERVED with movie_ID using service API', async () => {
      const result = await cats.tx({ user: "test" }, () => {
        return cats.update(Assets, availableAsset[0].ID, {
          status_code: 'RESERVED' ,
          movie_ID: 'MOVIE_123' 
        });
      });
      expect(result.status.code).to.equal('RESERVED');
      expect(result.movie.ID).to.equal('MOVIE_123');
    });

    it('should accept RESERVED with movie_ID using HTTP', async () => {
      console.log('Using asset ID:', availableAsset[0]?.ID);
      const { status } = await PATCH(`${basePath}('${availableAsset[0].ID}')`, {
        status: { code: 'RESERVED' },
        movie: { ID: 'MOVIE_123' }
      });      
      expect(status).toBe(200);
    });
  });
});