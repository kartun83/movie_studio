const cdsLib = require('@sap/cds');
const { SELECT: SELECT_QUERY } = cdsLib;

module.exports = async function(srv) {
  const { Assets } = srv.entities;

  // Get available assets by type
  srv.on('getAvailableAssets', async (req) => {
    const type = req.params[0];
    const tx = cdsLib.transaction(req);

    const assets = await tx.run(
      SELECT_QUERY.from(Assets)
        .where({ 
          'type.code': type,
          'status.code': 'AVAILABLE'
        })
    );

    return assets;
  });

  // Log registered handlers for debugging
  console.log('AssetsService registered');
}; 