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
}; 