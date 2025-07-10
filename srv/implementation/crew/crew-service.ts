import cds from '@sap/cds';

module.exports = async (srv: any) => {
  const { MovieProjects, CrewAssignments } = srv.entities;
  
  // Define department rules
  const DEPARTMENT_RULES: { [key: string]: string[] } = {
    'PLANNING': ['PRODUCTION_MANAGER', 'DIRECTOR', 'ASSISTANT_DIRECTOR'],
    'PRE_PRODUCTION': ['PRODUCTION_MANAGER', 'DIRECTOR', 'ASSISTANT_DIRECTOR', 'PRODUCTION_ASSISTANT'],
    'PRODUCTION': ['PRODUCTION_MANAGER', 'DIRECTOR', 'ASSISTANT_DIRECTOR', 'PRODUCTION_ASSISTANT', 'CAMERA_OPERATOR'],
    'POST_PRODUCTION': ['PRODUCTION_MANAGER', 'DIRECTOR', 'EDITOR', 'SOUND_ENGINEER'],
    'COMPLETED': ['PRODUCTION_MANAGER', 'DIRECTOR']
  };

  // ===== VALIDATION =====
  srv.before(['CREATE', 'UPDATE'], 'CrewAssignments', async (req: any) => {
    const assignment = req.data;
    const movie = await cds.read(MovieProjects).where({ ID: assignment.movie_ID }).limit(1);
    
    if (!isDepartmentAllowed(assignment.department_code, movie[0]?.status_code)) {
      req.error(400, 
        `Department ${assignment.department_code} not allowed in status ${movie[0]?.status_code}`);
    }
  });

  // ===== STATUS UPDATE =====
  srv.on('updateStatus', async (req: any) => {
    const { newStatus, ID } = req.data;
    const movie = await cds.read(MovieProjects).where({ ID }).limit(1);
    
    // Validate status transition
    const transitionValid = await validateStatusTransition(
      movie[0]?.status_code, newStatus.code);
    
    if (!transitionValid.allowed) {
      req.error(400, transitionValid.message);
      return;
    }

    // Update status
    await cds.update(MovieProjects).where({ ID }).with({ status_code: newStatus.code });
    
    // Handle crew assignments based on new status
    await handleStatusChangeEffects(ID, movie[0]?.status_code, newStatus.code);
    
    return { success: true, newStatus };
  });

  // ===== HELPER FUNCTIONS =====
  function isDepartmentAllowed(departmentCode: string, statusCode: string): boolean {
    const allowedDepartments = DEPARTMENT_RULES[statusCode] || [];
    return allowedDepartments.includes(departmentCode);
  }

  async function validateStatusTransition(fromStatusCode: string, toStatusCode: string) {
    if (fromStatusCode === toStatusCode) {
      return { allowed: false, message: 'Status unchanged' };
    }
    
    const transition = await cds.read('my.StatusTransition')
      .where({ fromStatus_code: fromStatusCode, toStatus_code: toStatusCode });
    
    return transition[0] || { 
      allowed: false, 
      message: 'Invalid status transition' 
    };
  }

  async function handleStatusChangeEffects(movieId: string, oldStatus: string, newStatus: string) {
    // Example: Make certain crew inactive when moving to post-production
    if (newStatus === 'POST_PRODUCTION') {
      await cds.update(CrewAssignments)
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
  srv.on('addCrewAssignment', async (req: any) => {
    const { person, department, roleDescription, movie } = req.data;
    
    // Get current movie status
    const movieData = await cds.read(MovieProjects).where({ ID: movie.ID }).limit(1);
    
    // Validate department against status
    if (!isDepartmentAllowed(department.code, movieData[0]?.status_code)) {
      throw new Error(`Department ${department.code} not allowed in current project status`);
    }
    
    // Create assignment
    const assignment = await cds.insert(CrewAssignments).entries({
      movie_ID: movie.ID,
      person_ID: person.ID,
      department_code: department.code,
      roleDescription,
      active: true
    });
    
    return assignment;
  });
  };