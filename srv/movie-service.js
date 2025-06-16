const cds = require('@sap/cds');
const projectService = require('./impl/project-service');
const budgetService = require('./impl/budget-service');
const releasesService = require('./impl/releases-service');

module.exports = async function(srv) {
  // Register all service implementations
  await projectService(srv);
  await budgetService(srv);
  await releasesService(srv);

  // Log registered handlers for debugging
  console.log('Registered handlers:', Object.keys(srv._handlers));
}; 