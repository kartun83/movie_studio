import cds from '@sap/cds';
import { BaseService } from '../logging/base-service';
type Location = { ID: string; isTechnical: boolean }; // Define or import generated types

class AssetsService extends BaseService {
  constructor() {
    super('AssetsService');
  }

  async init() {    
    // Rule 1: RETIRED assets cannot be modified or deleted
    this.before(['UPDATE', 'DELETE'], 'Assets', this.checkRetired);

    // Rule 2: Status transition rules
    this.before('UPDATE', 'Assets', this.checkStatus);
    this.before('CREATE', 'Assets', this.checkBeforeCreate);

    return await super.init();
  }

  private async checkStatus(req: cds.Request) {    
      if (req.data.status) {
        const newStatus = req.data.status.code || req.data.status;
        
        this.logBusinessRule('Assets', 'Status transition validation', { 
          oldStatus: req.data.status, 
          newStatus: newStatus,
          movieId: req.data.movie 
        });
        
        // When setting AVAILABLE, clear movie_ID
        if (newStatus === 'AVAILABLE' && req.data.movie) {
          this.logBusinessRule('Assets', 'Clearing movie_ID for AVAILABLE status', { 
            assetId: req.data.ID, 
            movieId: req.data.movie 
          });
          req.data.movie = null;
        }
        
        // RESERVED requires movie_ID
        if (newStatus === 'RESERVED' && !req.data.movie) {
          this.logValidation('Assets', 'RESERVED status', 'missing movie_ID', false);
          req.error(400, 'RESERVED status requires a movie_ID');
        } else {
          this.logValidation('Assets', 'RESERVED status', 'movie_ID present', true);
        }
      }
  }

  private async checkRetired(req:cds.Request) {
    const assetId = req.data.ID || req.params[0];
    
    this.logBusinessRule('Assets', 'Checking RETIRED status', { assetId });
    
    const asset = await this.timeOperation('read_asset', 'Assets', async () => {
      return await cds.read('com.kartun.movie_studio.Asset')
          .where({ ID: assetId })
          .limit(1);
    });
      
    if (asset && asset[0]?.status_code === 'RETIRED') {
      this.logValidation('Assets', 'RETIRED status check', assetId, false);
      req.error(403, 'RETIRED assets cannot be modified or deleted');
    } else {
      this.logValidation('Assets', 'RETIRED status check', assetId, true);
    }
  }

  private async checkBeforeCreate(req:cds.Request) {
    this.logBusinessRule('Assets', 'Pre-create validation', { 
      status: req.data.status?.code, 
      movieId: req.data.movie 
    });

    // AVAILABLE assets cannot have movie_ID
    if (req.data.status?.code === 'AVAILABLE' && req.data.movie) {
      this.logValidation('Assets', 'AVAILABLE with movie_ID', req.data.movie, false);
      req.error(400, 'AVAILABLE assets cannot have a movie_ID');
    }

    // RESERVED assets must have movie_ID
    if (req.data.status?.code === 'RESERVED' && !req.data.movie) {
      this.logValidation('Assets', 'RESERVED without movie_ID', 'missing', false);
      req.error(400, 'RESERVED status requires a movie_ID');
    }
  }  

  private async getAvailableAssets(req: cds.Request) {
    const type = req.data?.type;
    
    this.logBusinessRule('Assets', 'Get available assets', { type });
    
    if (!type) {
      this.logValidation('Assets', 'type parameter', type, false);
      req.error(400, 'type parameter is required');
      return;
    }
    
    this.logValidation('Assets', 'type parameter', type, true);
    
    return await this.timeOperation('get_available_assets', 'Assets', async () => {
      return cds.read('Assets').where({ type_code: type, status_code: 'AVAILABLE' });
    });
  }

  private async sleep(req: cds.Request) {
    try {
        let dbQuery = ' Call "sleep"( )'
        let result = await cds.run(dbQuery, { })
        console.info(result)
        return true
    } catch (error: unknown) {
        console.error(error)
        return false
    }
  }
}

module.exports = AssetsService;