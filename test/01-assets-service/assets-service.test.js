import cds from '@sap/cds';
const { GET, POST, PATCH, DELETE, expect } = cds.test('serve','srv/assets-service.cds').in(__dirname+'/..')
import { Asset, Location } from '../../db/core/'; // Generated types

describe('AssetsService', () => {
  


  beforeAll(async () => {
    await cds.deploy(__dirname + '/../db/schema').to('sqlite::memory:');
    await cds.serve('AssetsService').from(__dirname + '/../srv/assets-service');

    // Seed test data
    technicalLocation = await cds.create(Location, {
      ID: 'TECH_1',
      name: 'Warehouse A',
      isTechnical: true
    });

    testAsset = await cds.create('Asset', {
      ID: 'ASSET_1',
      name: 'Test Camera',
      type: 'CAMERA',
      status_code: 'AVAILABLE',
      location_ID: technicalLocation.ID
    });
  });

  // --- Rule 1: RETIRED assets cannot be modified ---
  describe('RETIRED assets', () => {
    beforeAll(async () => {
      await PATCH(`/Assets('ASSET_1')`, { status_code: 'RETIRED' });
    });

    it('should forbid PATCH on RETIRED assets', async () => {
      const response = await PATCH(`/Assets('ASSET_1')`, { name: 'Modified Name' });
      expect(response.status).toBe(403);
    });

    it('should forbid DELETE on RETIRED assets', async () => {
      const response = await DELETE(`/Assets('ASSET_1')`);
      expect(response.status).toBe(403);
    });
  });

  // --- Rule 2: Status transition rules ---
  describe('Status transitions', () => {
    it('should clear movie_ID when setting AVAILABLE', async () => {
      const { status, data } = await PATCH(`/Assets('ASSET_1')`, { 
        status_code: 'AVAILABLE',
        movie_ID: 'MOVIE_123' // Should be ignored/cleared
      });
      expect(status).toBe(200);
      expect(data.movie_ID).toBeNull();
    });

    it('should forbid AVAILABLE with movie_ID', async () => {
      const response = await POST('/Assets', {
        name: 'New Asset',
        status_code: 'AVAILABLE',
        movie_ID: 'MOVIE_123', // Invalid combination
        location_ID: technicalLocation.ID
      });
      expect(response.status).toBe(400);
    });

    it('should require movie_ID for RESERVED', async () => {
      const response = await PATCH(`/Assets('ASSET_1')`, {
        status_code: 'RESERVED' // Missing movie_ID
      });
      expect(response.status).toBe(400);
    });

    it('should accept RESERVED with movie_ID', async () => {
      const { status } = await PATCH(`/Assets('ASSET_1')`, {
        status_code: 'RESERVED',
        movie_ID: 'MOVIE_123'
      });
      expect(status).toBe(200);
    });
  });
});