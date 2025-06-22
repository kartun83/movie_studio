const cds = require('@sap/cds');
const projectService = require('./handlers/project-service');
const budgetService = require('./handlers/budget-service');
const releasesService = require('./handlers/releases-service');
const movieService = require('./handlers/movie-service');
const crewService = require('./handlers/crew-service');
const loggingService = require('./handlers/logging-service');
const assetsService = require('./handlers/assets-service');

module.exports = async function(srv) {
  // Register all service implementations
  await projectService(srv);
  await budgetService(srv);
  await releasesService(srv);
  await movieService(srv);
  await crewService(srv);
  await loggingService(srv);
  await assetsService(srv);

  // Log registered handlers for debugging
  console.log('Registered handlers:', Object.keys(srv._handlers));
}; 