using com.kartun.movie_studio as M from '../../../db/schema';


/**
 * Serves administrators managing everything
 */
service AdminService @(path: '/admin') {

    entity Movies as projection on M.MovieProject;
    entity Assets as projection on M.Asset;
    entity Expenses as projection on M.Expense;
    entity Contracts as projection on M.Contract;
    entity Distributions as projection on M.DistributionRight;
    // entity ProductionLogs as projection on M.ProductionLog;
    entity Locations as projection on M.Location;
    // entity Crew as projection on M.;
    // entity Casting as projection on M.Casting;
}