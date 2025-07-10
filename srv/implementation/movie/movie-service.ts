import cds from '@sap/cds';
import { BaseService } from '../logging/base-service';

export default class MovieService extends BaseService {
  constructor() {
    super('MovieService');
  }

  async init() {
    // --- BEFORE Handler: Clean input before insert ---
    this.before('CREATE', 'Movies', this.checkCreate);

    // --- AFTER Handler: Logging with business rule ---
    this.after('CREATE', 'Movies', this.logMovieCreated);

    await super.init();
  }


    // --- BEFORE Handler: Clean input before insert ---
    private async checkCreate(req: cds.Request){
      this.logBusinessRule('Movies', 'Title validation', { title: req.data.title });
      
      if (!req.data.title || req.data.title.trim() === '') {
        this.logValidation('Movies', 'title', req.data.title, false);
        return req.reject(400, 'Movie title must not be empty.');
      }
      
      req.data.title = req.data.title.trim();
      this.logValidation('Movies', 'title', req.data.title, true);
    }

    // --- AFTER Handler: Logging with business rule ---
    private async logMovieCreated(data: any, req: cds.Request) {
      this.logBusinessRule('Movies', 'Movie created successfully', { 
        id: data.ID, 
        title: data.title,
        user: req.user?.id 
      });
    }
}

module.exports = MovieService;