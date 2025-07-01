import cds from '@sap/cds';
type Location = { ID: string; isTechnical: boolean }; // Define or import generated types

class AssetsService extends cds.ApplicationService {
  async init() {    
    // Rule 1: RETIRED assets cannot be modified or deleted
    this.before(['UPDATE', 'DELETE'], 'Assets', this.checkRetired);

    // Rule 2: Status transition rules
    this.before('UPDATE', 'Assets', this.checkStatus);
    this.before('CREATE', 'Assets', this.checkBeforeCreate);

    // Custom functions
    this.on('getAvailableAssets', this.getAvailableAssets);
    this.on('sleep', this.sleep);
    return await super.init();
  }

  private async checkStatus(req: cds.Request) {    
      if (req.data.status) {
        const newStatus = req.data.status.code || req.data.status;
        
        // When setting AVAILABLE, clear movie_ID
        if (newStatus === 'AVAILABLE' && req.data.movie) {
          req.data.movie = null;
        }
        
        // RESERVED requires movie_ID
        if (newStatus === 'RESERVED' && !req.data.movie) {
          req.error(400, 'RESERVED status requires a movie_ID');
        }
      }
  }

  private async checkRetired(req:cds.Request) {
    const asset = await cds.read('com.kartun.movie_studio.Asset')
        .where({ ID: req.data.ID || req.params[0] })
        .limit(1);
      
      if (asset && asset[0]?.status_code === 'RETIRED') {
        req.error(403, 'RETIRED assets cannot be modified or deleted');
      }
  }

  private async checkBeforeCreate(req:cds.Request) {
    // AVAILABLE assets cannot have movie_ID
    if (req.data.status?.code === 'AVAILABLE' && req.data.movie) {
      req.error(400, 'AVAILABLE assets cannot have a movie_ID');
    }

    // RESERVED assets must have movie_ID
    if (req.data.status?.code === 'RESERVED' && !req.data.movie) {
      req.error(400, 'RESERVED status requires a movie_ID');
    }
  }  

  private async getAvailableAssets(req: cds.Request) {
    const type = req.data?.type;
    if (!type) {
      req.error(400, 'type parameter is required');
      return;
    }
    return cds.read('Assets').where({ type_code: type, status_code: 'AVAILABLE' });
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