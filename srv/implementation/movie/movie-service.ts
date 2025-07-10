import cds from '@sap/cds';

export default class MovieService extends cds.ApplicationService {
  async init() {
    
      await super.init();
      
      // Add computed field for director full name
      this.after('READ', 'Movies', (results) => {
        if (Array.isArray(results)) {
          results.forEach(movie => {
            if (movie.director && movie.director.firstName && movie.director.lastName) {
              movie.directorFullName = `${movie.director.firstName} ${movie.director.lastName}`;
            }
          });
        }
      });

      // --- BEFORE Handler: Clean input before insert ---
      // this.before('CREATE', 'Movies', this.checkCreate);

      // // --- AFTER Handler: Logging ---
      // this.after('CREATE', 'Movies', (data, req) => {
      //   console.log(`Movie created: ${data.ID} - ${data.title}`);
      // });
    };

    private async checkCreate(req: cds.Request){
      console.log('checkCreate');
      if (!req.data.title || req.data.title.trim() === '') {
        return req.reject(400, 'Movie title must not be empty.');
      }
      req.data.title = req.data.title.trim();
    }
}

module.exports = MovieService;