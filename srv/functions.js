module.exports = cds.service.impl(async function() {
this.on('getTotalBudget', async ({ params }) => {
    const result = await cds.read(MovieProject, q => q
      .where({ 'genre_primary.code': params.genre })
      .columns([ { func: 'sum', args: ['budget'], as: 'total' } ]));
    return result[0].total || 0;
  });
});