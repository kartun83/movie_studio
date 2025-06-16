const { getTransaction, SELECT } = require('./base-service');

module.exports = async function(srv) {
  const { MovieProject } = srv.entities;

  srv.on('getTotalBudget', async (req) => {
    const { genre } = req.params;
    const tx = getTransaction(req);

    const result = await tx.run(
      SELECT.from(MovieProject)
        .where({ 'genre_primary.code': genre })
        .columns([{ func: 'sum', args: ['budget'], as: 'total' }])
    );

    return result[0].total || 0;
  });

  // --- FUNCTION: Return budget stats by status ---
  srv.on('getBudgetStatsFor', async (req) => {
    const { status } = req.data;
    const tx = cds.transaction(req);

    const query = SELECT.one
      .columns([
        'count(*) as count',
        'sum(budget) as total',
        'avg(budget) as avg'
      ])
      .from(MovieProject)
      .where({ status_code: status });

    const result = await tx.run(query);
    return result || { count: 0, total: 0, avg: 0 };
  });
}; 