const cds = require("@sap/cds");
// Relative path to root folder
const rel_path = '/../..';
// const { GET, POST, PATCH, DELETE, expect } = cds.test('serve','srv/assets-service.cds').in(__dirname+'/..')
const { GET, POST, PATCH, DELETE, expect } = cds.test('serve',
                                                      "AssetsService",
                                                      "--from",
                                                      "schema").in(__dirname+rel_path);

describe('AssetsService', () => {
  let warehouseLocation, retiredAsset, availableAsset;

  beforeAll(async () => {
    await cds.deploy(__dirname + rel_path + '/db/schema').to('sqlite::memory:');
    await cds.serve('AssetsService').from(__dirname + rel_path + '/srv/assets-service');

    // Use existing data from CSV files
    // Warehouse A location from CSV
    warehouseLocation = await cds.read('com.kartun.movie_studio.Location').where({ name: 'Warehouse A' });
    
    // Find a RETIRED asset from CSV
    retiredAsset = await cds.read('com.kartun.movie_studio.Asset').where({ status_code: 'RETIRED' });
    
    // Find an AVAILABLE asset from CSV
    availableAsset = await cds.read('com.kartun.movie_studio.Asset').where({ status_code: 'AVAILABLE' });
  });

  // --- Rule 1: RETIRED assets cannot be modified ---
  describe('RETIRED assets', () => {
    it('should forbid PATCH on RETIRED assets', async () => {
      const response = await PATCH(`/Assets('${retiredAsset[0].ID}')`, { name: 'Modified Name' });
      expect(response.status).toBe(403);
    });

    it('should forbid DELETE on RETIRED assets', async () => {
      const response = await DELETE(`/Assets('${retiredAsset[0].ID}')`);
      expect(response.status).toBe(403);
    });
  });

  // --- Rule 2: Status transition rules ---
  describe('Status transitions', () => {
    it('should clear movie_ID when setting AVAILABLE', async () => {
      const { status, data } = await PATCH(`/Assets('${availableAsset[0].ID}')`, { 
        status: { code: 'AVAILABLE' },
        movie: { ID: 'MOVIE_123' } // Should be ignored/cleared
      });
      expect(status).toBe(200);
      expect(data.movie).toBeNull();
    });

    it('should forbid AVAILABLE with movie_ID', async () => {
      const response = await POST('/Assets', {
        name: 'New Asset',
        status: { code: 'AVAILABLE' },
        movie: { ID: 'MOVIE_123' }, // Invalid combination
        location: { ID: warehouseLocation[0].ID },
        type: { code: 'CAMERA' }
      });
      expect(response.status).toBe(400);
    });

    it('should require movie_ID for RESERVED', async () => {
      const response = await PATCH(`/Assets('${availableAsset[0].ID}')`, {
        status: { code: 'RESERVED' } // Missing movie_ID
      });
      expect(response.status).toBe(400);
    });

    it('should accept RESERVED with movie_ID', async () => {
      const { status } = await PATCH(`/Assets('${availableAsset[0].ID}')`, {
        status: { code: 'RESERVED' },
        movie: { ID: 'MOVIE_123' }
      });
      expect(status).toBe(200);
    });
  });
});