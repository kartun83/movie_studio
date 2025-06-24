import cds from '@sap/cds';

export default class MovieService extends cds.ApplicationService {
  async init() {
    
      await super.init();
      // --- BEFORE Handler: Clean input before insert ---
      this.before('CREATE', 'Movies', this.checkCreate);

      // --- ON Handler: Custom READ handler using CQL ---
      this.on('READ', 'Movies', this.getMovies);

      // --- AFTER Handler: Logging ---
      this.after('CREATE', 'Movies', (data, req) => {
        console.log(`Movie created: ${data.ID} - ${data.title}`);
      });

      // --- ACTION: Cancel a movie ---
      this.on('cancelMovie', this.cancelMovie);
    };

    private async checkCreate(req: cds.Request){
      if (!req.data.title || req.data.title.trim() === '') {
        return req.reject(400, 'Movie title must not be empty.');
      }
      req.data.title = req.data.title.trim();
    }

    private async getMovies(req: cds.Request){
      const tx = cds.transaction(req);
      const movies = await tx.run(SELECT.from('MovieProject').limit(100));
      return movies;
    }

    private async cancelMovie(req: cds.Request){
      const { movieID } = req.data;
      const tx = cds.transaction(req);

      const movie = await tx.run(SELECT.one.from('MovieProject').where({ ID: movieID }));
      if (!movie) return req.reject(404, `Movie with ID ${movieID} not found`);

      // Update the movie's status to CANCELLED
      await tx.run(
        UPDATE('MovieProject')
          .set({ status_code: 'CANCELLED' })
          .where({ ID: movieID })
      );
      return true;
    }

    private async getTotalBudget(req: cds.Request) {
      if (!req || !req.data) {
        console.log('Request data is missing');
        req?.error?.(400, 'Request data is missing');
        return;
      }
      const movieID = req.data.movie_ID || req.data.ID;
      if (!movieID) {
        req.error(400, 'movie_ID is required');
        return;
      }

      // Sum all expenses for the given movie
      const result = await cds.run(
        SELECT
          .from('com.kartun.movie_studio.Expense')
          .columns('currency', { sum: { as: 'total', expr: 'amount' } })
          .where({ movie_ID: movieID })
          .groupBy('currency')
      );

      return { totals: result };
    }
}

module.exports = MovieService;