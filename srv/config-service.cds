using com.kartun.movie_studio as db from '../db/schema';
using { Country, Language } from '@sap/cds/common';



/**
 * Serves administrators managing everything
 */
service ConfigService @(path: '/config') {

    // entity Countries as projection on db.Countries;
    // entity Languages as projection on db.Languages;
    entity Genres as projection on db.GenreType;
    entity Departments as projection on db.Department;
    entity Roles as projection on db.PersonRole;
    entity Locations as projection on db.Location;
    entity AssetTypes as projection on db.AssetType;
    entity AssetStatuses as projection on db.AssetStatus;
    entity ExpenseCategory as projection on db.ExpenseCategory;
    entity PlatformType as projection on db.PlatformType;
    entity ProjectStatus as projection on db.ProjectStatus;
    // entity AssetLocations as projection on db.Location;
}