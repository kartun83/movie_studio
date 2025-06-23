import cds from '@sap/cds';
type Location = { ID: string; isTechnical: boolean }; // Define or import generated types

export default class AssetsService extends cds.ApplicationService {
  async init() {
    await super.init();

    this.before('CREATE', 'Assets', async (req) => {
      const [location] = await cds.read('movie_studio.Location')
        .where({ ID: req.data.location_ID })
        .limit(1);
      if (!location?.isTechnical) {
        req.error(400, "Assets require technical locations");
      }
    });

    this.on('getAvailableAssets', async (req) => {
      return cds.read('Assets').where({ type: req.params[0] });
    });
  }
}