const cds = require('@sap/cds');

module.exports = cds.service.impl(async function (srv) {
  const { MovieProject } = cds.entities('com.kartun.movie_studio');

  // --- BEFORE Handler: Clean input before insert ---
  srv.before('CREATE', 'Movies', async (req) => {
    if (!req.data.title || req.data.title.trim() === '') {
      return req.reject(400, 'Movie title must not be empty.');
    }
    req.data.title = req.data.title.trim();
  });

  // --- ON Handler: Custom READ handler using CQL ---
  srv.on('READ', 'Movies', async (req) => {
    const tx = cds.transaction(req);
    const movies = await tx.run(SELECT.from(MovieProject).limit(100));
    return movies;
  });

  // --- AFTER Handler: Logging ---
  srv.after('CREATE', 'Movies', (data, req) => {
    console.log(`Movie created: ${data.ID} - ${data.title}`);
  });

  // --- ACTION: Cancel a movie ---
  srv.on('cancelMovie', async (req) => {
    const { movieID } = req.data;
    const tx = cds.transaction(req);

    const movie = await tx.run(SELECT.one.from(MovieProject).where({ ID: movieID }));
    if (!movie) return req.reject(404, `Movie with ID ${movieID} not found`);

    // Update the movie's status to CANCELLED
    await tx.run(
      UPDATE(MovieProject)
        .set({ status_code: 'CANCELLED' })
        .where({ ID: movieID })
    );
    return true;
  });
});