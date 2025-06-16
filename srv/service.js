// File: srv/service.js
const cds = require('@sap/cds');
module.exports = function (srv) {
  srv.on('READ', 'UpcomingReleases', async (req) => {
    const { earliest, latest } = req.data;
    const dbKind = cds.env.requires.db.kind;

    const tx = cds.transaction(req);
    let query = SELECT.from('my.UpcomingReleases');

    if (dbKind === 'sqlite') {
      if (earliest && latest) {
        query.where({ releaseDate: { '>=': earliest, '<=': latest } });
      }
    } else {
      // HANA: use the parameterized view directly
      query = SELECT.from('my.UpcomingReleases', { earliest, latest });
    }

    return tx.run(query);
  });
};