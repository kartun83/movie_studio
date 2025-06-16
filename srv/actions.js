// srv/movie-service.js
module.exports = cds.service.impl(async function() {
    const { MovieProject, ProductionStatusLog } = this.entities;
  
    this.on('closeProject', async (req) => {
      const { projectId, finalComment } = req.data;
      await UPDATE(MovieProject)
        .set({ status_code: 'CLOSED' })
        .where({ ID: projectId });
      await INSERT.into(ProductionStatusLog).entries({
        movie_ID: projectId,
        status_code: 'CLOSED',
        comment: finalComment,
        timestamp: new Date()
      });
      return SELECT.one.from(MovieProject).where({ ID: projectId });
    });
  });