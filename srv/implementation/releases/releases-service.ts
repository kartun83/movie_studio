import cds from '@sap/cds';

module.exports = async function(srv: any) {
  srv.on('READ', 'UpcomingReleases', async (req: any) => {
    const { earliest, latest } = req.data;
    const dbKind = cds.db.kind;
    const tx = cds.transaction(req);

    let query = cds.read('MovieService.UpcomingReleases');

    if (dbKind === 'sqlite') {
      if (earliest && latest) {
        query.where({ releaseDate: { '>=': earliest, '<=': latest } });
      }
    } else {
      // HANA: use the parameterized view directly
      query = cds.read('MovieService.UpcomingReleases', { earliest, latest });
    }

    return await query;
  });
}; 