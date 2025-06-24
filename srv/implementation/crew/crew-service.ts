const { getTransaction, SELECT, UPDATE, INSERT } = require('./base-service');

  module.exports = async (srv) => {
    const { MovieProjects, CrewAssignments } = srv.entities;
  
    // ===== VALIDATION =====
    srv.before(['CREATE', 'UPDATE'], 'CrewAssignments', async (req) => {
      const assignment = req.data;
      const movie = await SELECT.one.from(MovieProjects, assignment.movie_ID)
        .columns('status_code');
      
      if (!isDepartmentAllowed(assignment.department_code, movie.status_code)) {
        req.error(400, 
          `Department ${assignment.department_code} not allowed in status ${movie.status_code}`);
      }
    });
  
    // ===== STATUS UPDATE =====
    srv.on('updateStatus', async (req) => {
      const { newStatus, ID } = req.data;
      const movie = await SELECT.one.from(MovieProjects, ID)
        .columns('status_code');
      
      // Validate status transition
      const transitionValid = await validateStatusTransition(
        movie.status_code, newStatus.code);
      
      if (!transitionValid.allowed) {
        req.error(400, transitionValid.message);
        return;
      }
  
      // Update status
      await UPDATE(MovieProjects, ID).with({ status_code: newStatus.code });
      
      // Handle crew assignments based on new status
      await handleStatusChangeEffects(ID, movie.status_code, newStatus.code);
      
      return { success: true, newStatus };
    });
  
    // ===== HELPER FUNCTIONS =====
    function isDepartmentAllowed(departmentCode, statusCode) {
      const allowedDepartments = DEPARTMENT_RULES[statusCode] || [];
      return allowedDepartments.includes(departmentCode);
    }
  
    async function validateStatusTransition(fromStatusCode, toStatusCode) {
      if (fromStatusCode === toStatusCode) {
        return { allowed: false, message: 'Status unchanged' };
      }
      
      const transition = await SELECT.one.from('my.StatusTransition')
        .where({ fromStatus_code: fromStatusCode, toStatus_code: toStatusCode });
      
      return transition || { 
        allowed: false, 
        message: 'Invalid status transition' 
      };
    }
  
    async function handleStatusChangeEffects(movieId, oldStatus, newStatus) {
      // Example: Make certain crew inactive when moving to post-production
      if (newStatus === 'POST_PRODUCTION') {
        await UPDATE(CrewAssignments)
          .where({ movie_ID: movieId, department_code: ['IN', ['PRODUCTION_ASSISTANT']] })
          .with({ active: false });
      }
      
      // Emit status change event
      await srv.emit('movieStatusChanged', {
        movie: { ID: movieId },
        oldStatus: { code: oldStatus },
        newStatus: { code: newStatus }
      });
    }
  
    // ===== CUSTOM OPERATIONS =====
    srv.on('addCrewAssignment', async (req) => {
      const { person, department, roleDescription, movie } = req.data;
      
      // Get current movie status
      const movieData = await SELECT.one.from(MovieProjects, movie.ID)
        .columns('status_code');
      
      // Validate department against status
      if (!isDepartmentAllowed(department.code, movieData.status_code)) {
        throw new Error(`Department ${department.code} not allowed in current project status`);
      }
      
      // Create assignment
      const assignment = await INSERT.into(CrewAssignments).entries({
        movie_ID: movie.ID,
        person_ID: person.ID,
        department_code: department.code,
        roleDescription,
        active: true
      });
      
      return assignment;
    });
  };