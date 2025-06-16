const { getDbKind, getTransaction, SELECT } = require('./base-service');

module.exports = async function(srv) {
  srv.on('READ', 'UpcomingReleases', async (req) => {
    const { earliest, latest } = req.data;
    const dbKind = getDbKind();
    const tx = getTransaction(req);

    let query = SELECT.from('MovieService.UpcomingReleases');

    if (dbKind === 'sqlite') {
      if (earliest && latest) {
        query.where({ releaseDate: { '>=': earliest, '<=': latest } });
      }
    } else {
      // HANA: use the parameterized view directly
      query = SELECT.from('MovieService.UpcomingReleases', { earliest, latest });
    }

    return tx.run(query);
  });
}; 