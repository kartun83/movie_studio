import cds from '@sap/cds';

const { MovieProject, ProjectStatus, ProductionStatusLog } = cds.entities('com.kartun.movie_studio');

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
      this.on('closeProject', (req) => this.updateStatusAndLog(req, 'RELEASED'));
      this.on('cancelProject', (req) => this.updateStatusAndLog(req, 'CANCELLED'));

      // --- BEFORE Handler: Clean input before insert ---
      // this.before('CREATE', 'Movies', this.checkCreate);

      // // --- AFTER Handler: Logging ---
      // this.after('CREATE', 'Movies', (data, req) => {
      //   console.log(`Movie created: ${data.ID} - ${data.title}`);
      // });

      // Castings CRUD operations
      this.before(['CREATE', 'UPDATE'], 'Castings', this.validateCasting);
      this.after('CREATE', 'Castings', (data, req) => this.logCastingOperation(req));
      this.after('UPDATE', 'Castings', (data, req) => this.logCastingOperation(req));
      this.after('DELETE', 'Castings', (data, req) => this.logCastingOperation(req));

      // Expenses CRUD operations
      this.before(['CREATE', 'UPDATE'], 'Expenses', this.validateExpense);
      this.after('CREATE', 'Expenses', (data, req) => this.logExpenseOperation(req));
      this.after('UPDATE', 'Expenses', (data, req) => this.logExpenseOperation(req));
      this.after('DELETE', 'Expenses', (data, req) => this.logExpenseOperation(req));
    };

    private async checkCreate(req: cds.Request){
      console.log('checkCreate');
      if (!req.data.title || req.data.title.trim() === '') {
        return req.reject(400, 'Movie title must not be empty.');
      }
      req.data.title = req.data.title.trim();
    }

    private async updateStatusAndLog(req: any, newStatusCode: string): Promise<string> {
      const { ID, finalComment } = req.data;
  
      console.log('req', req.data);
      // Get the target movie
      const movie = await SELECT.one.from(MovieProject).where({ ID });
      if (!movie) return req.error(404, `Movie ${ID} not found`);
  
      // Check if already in desired status
      const currentStatus = await SELECT.one.from(ProjectStatus).columns('code').where({ ID: movie.status_ID });
      if (currentStatus?.code === newStatusCode) {
        return req.reject(400, `Movie is already in status ${newStatusCode}`);
      }
  
      // Get the ProjectStatus entity for new status
      const newStatus = await SELECT.one.from(ProjectStatus).where({ code: newStatusCode });
      if (!newStatus) return req.reject(400, `Invalid status '${newStatusCode}'`);
  
      // Update the movie status
      await UPDATE(MovieProject)
        .set({
          status_ID: newStatus.ID,
          modifiedAt: new Date()
        })
        .where({ ID });
  
      // Insert into productionStatusLogs
      await INSERT.into(ProductionStatusLog).entries({
        movie_ID: ID,
        status_ID: newStatus.ID,
        timestamp: new Date(),
        comment: finalComment
      });
  
      return `Movie marked as ${newStatusCode}`;
    }  

    private async validateCasting(req: cds.Request) {
      const casting = req.data;
      
      // Validate required fields
      if (!casting.characterName || casting.characterName.trim() === '') {
        return req.reject(400, 'Character name is required.');
      }
      
      if (!casting.person_ID) {
        return req.reject(400, 'Person must be selected.');
      }
      
      if (casting.isLeadRole === undefined) {
        casting.isLeadRole = false; // Default to false if not specified
      }
      
      // Clean up character name
      casting.characterName = casting.characterName.trim();
    }

    private async validateExpense(req: cds.Request) {
      const expense = req.data;
      
      // Validate required fields
      if (!expense.amount || expense.amount <= 0) {
        return req.reject(400, 'Amount must be greater than 0.');
      }
      
      if (!expense.date) {
        return req.reject(400, 'Date is required.');
      }
      
      if (!expense.description || expense.description.trim() === '') {
        return req.reject(400, 'Description is required.');
      }
      
      if (!expense.category_code) {
        return req.reject(400, 'Category must be selected.');
      }
      
      // Clean up description
      expense.description = expense.description.trim();
    }

    private async logCastingOperation(req: cds.Request) {
      const operation = req.event;
      const casting = req.data;
      console.log(`Casting ${operation}: ${casting.ID} - ${casting.characterName}`);
    }

    private async logExpenseOperation(req: cds.Request) {
      const operation = req.event;
      const expense = req.data;
      console.log(`Expense ${operation}: ${expense.ID} - ${expense.description} (${expense.amount})`);
    }
}

module.exports = MovieService;