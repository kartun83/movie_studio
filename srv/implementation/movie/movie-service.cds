using com.kartun.movie_studio as M from '../../../db/schema';
// using { Currency, cuid } from '@sap/cds/common';

service MovieService {

  @odata.draft.enabled: true
  @cds.redirection.target: true
  // @assert.range: [budget, 0, 1e10]   // budget >= 0
  entity Movies as projection on M.MovieProject {
    ID,
    title,
    budget @(assert.range: [0, 1e10])
  }

  entity Persons as projection on M.Person {
    ID,
    name @assert.notNull
  }

  entity Castings as projection on M.Casting;
  entity Expenses as projection on M.Expense;
  entity Assets as projection on M.Asset;

  function getTotalBudget(    
  ) returns Decimal(15,2);

  action closeProject(
    projectId : UUID,
    finalComment : String(255)
  ) returns Movies
    @odata.contained: false;

  entity UpcomingReleases as projection on M.MovieProject {
    ID,
    title,
    releaseDate,
    status.code as status
  };
}

annotate MovieService.Movies with @odata.draft.enabled;
annotate MovieService.Movies with @fiori.draft.enabled;
