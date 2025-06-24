import cds from '@sap/cds';
type Location = { ID: string; isTechnical: boolean }; // Define or import generated types

export default class AssetsService extends cds.ApplicationService {
  async init() {
    await super.init();

    // Rule 1: RETIRED assets cannot be modified or deleted
    this.before(['UPDATE', 'DELETE'], 'Assets', async (req) => {
      const asset = await cds.read('com.kartun.movie_studio.Asset')
        .where({ ID: req.data.ID || req.params[0] })
        .limit(1);
      
      if (asset && asset[0]?.status_code === 'RETIRED') {
        req.error(403, 'RETIRED assets cannot be modified or deleted');
      }
    });

    // Rule 2: Status transition rules
    this.before('UPDATE', 'Assets', async (req) => {
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
    });

    this.before('CREATE', 'Assets', async (req) => {
      // AVAILABLE assets cannot have movie_ID
      if (req.data.status?.code === 'AVAILABLE' && req.data.movie) {
        req.error(400, 'AVAILABLE assets cannot have a movie_ID');
      }
      
      // RESERVED assets must have movie_ID
      if (req.data.status?.code === 'RESERVED' && !req.data.movie) {
        req.error(400, 'RESERVED status requires a movie_ID');
      }
    });

    this.on('getAvailableAssets', async (req) => {
      return cds.read('Assets').where({ type: req.params[0] });
    });
  }
}