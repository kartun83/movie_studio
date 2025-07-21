using com.kartun.movie_studio as M from '../../../db/schema';
// using { Currency, cuid } from '@sap/cds/common';

service MovieService @(path: '/movie') {

  // @odata.draft.enabled: true
  // @cds.redirection.target: true
  // @assert.range: [budget, 0, 1e10]   // budget >= 0
  entity Movies as projection on M.MovieProject {
    ID,
    title,
    budget @(assert.range: [0, 1e10]),    
    currency,    
    genre_primary,
    genre_secondary,
    status,
    createdAt,
    createdBy,
    director,
    modifiedAt,
    modifiedBy,
    releaseDate,    
    expenses,
    castings,
    productionStatusLogs,    
  }

  // Bound actions and functions have a binding parameter that is usually implicit. It can also be modeled explicitly: the first parameter of a bound action or function is treated as binding parameter, if it's typed by [many] $self. Use Explicit Binding to control the naming of the binding parameter. Use the keyword many to indicate that the action or function is bound to a collection of instances rather than to a single one.
  actions{
    action closeProject(finalComment : String(255));
    action cancelProject(finalComment : String(255));
  }

  entity Persons as projection on M.Person {
    ID,
    firstName @assert.notNull,
    lastName @assert.notNull,
  }

  entity Castings as projection on M.Casting;
  entity Expenses as projection on M.Expense;
  entity Assets as projection on M.Asset;

  function getTotalBudget(    
  ) returns Decimal(15,2);

  

  // action closeProject(
  //   projectId : UUID,
  //   finalComment : String(255)
  // ) returns Movies
  //   @odata.contained: false;

  // action cancelProject(projectId : UUID,
  //   finalComment : String(255)
  // ) returns Movies
  //   @odata.contained: false;

  // entity UpcomingReleases as projection on M.MovieProject {
  //   ID,
  //   title,
  //   releaseDate,
  //   status.code as status
  // };
}

annotate MovieService.Movies with @(odata.draft.enabled: true, fiori.draft.enabled: true);

// Enable draft support for subentities
annotate MovieService.Castings with @(odata.draft.enabled, fiori.draft.enabled);

annotate MovieService.Expenses with @(odata.draft.enabled:true, fiori.draft.enabled:true);

// annotate MovieService.Assets. with @odata.draft.enabled;

// annotate MovieService.Movies with @(odata.draft.enabled, fiori.draft.enabled );
//annotate MovieService.Movies with @fiori.draft.enabled;

//annotate MovieService.Movies with @cds.redirection.target: true;