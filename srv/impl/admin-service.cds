using com.kartun.movie_studio as db from '../db/schema';


/**
 * Serves administrators managing everything
 */
service AdminService @(path: '/admin') {

    entity Movies as projection on db.MovieProject;
    entity Assets as projection on db.Asset;
    entity Expenses as projection on db.Expense;
    entity Contracts as projection on db.Contract;
    entity Distributions as projection on db.Distribution;
    // entity ProductionLogs as projection on db.ProductionLog;
    entity Locations as projection on db.Location;
    entity Crew as projection on db.Crew;
    // entity Casting as projection on db.Casting;
}