const { getTransaction, UPDATE, INSERT, SELECT } = require('./base-service');

module.exports = async function(srv) {
  const { MovieProject, ProductionStatusLog } = srv.entities;

  // Register the closeProject action
  srv.on('closeProject', 'MovieService', async (req) => {
    const { projectId, finalComment } = req.data;
    const tx = getTransaction(req);

    // Update project status
    await tx.run(
      UPDATE(MovieProject)
        .set({ status_code: 'CLOSED' })
        .where({ ID: projectId })
    );

    // Create status log entry
    await tx.run(
      INSERT.into(ProductionStatusLog).entries({
        movie_ID: projectId,
        status_code: 'CLOSED',
        comment: finalComment,
        timestamp: new Date()
      })
    );

    // Return updated project
    const result = await tx.run(
      SELECT.one.from(MovieProject).where({ ID: projectId })
    );

    return result;
  });
}; 