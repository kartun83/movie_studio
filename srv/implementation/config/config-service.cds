using com.kartun.movie_studio as M from '../../../db/schema';
using { Country, Language } from '@sap/cds/common';



/**
 * Serves administrators managing everything
 */
service ConfigService @(path: '/config') @(requires: ['Consultant','authenticated-user']) {

    // entity Countries as projection on M.Countries;
    // entity Languages as projection on M.Languages;
    entity Genres as projection on M.GenreType;
    entity Departments as projection on M.Department;
    entity Roles as projection on M.PersonRole;
    entity Locations as projection on M.Location;
    entity AssetTypes as projection on M.AssetType;
    entity AssetStatuses as projection on M.AssetStatus;
    entity ExpenseCategory as projection on M.ExpenseCategory;
    entity PlatformType as projection on M.PlatformType;
    entity ProjectStatus as projection on M.ProjectStatus;
    // entity AssetLocations as projection on M.Location;
}