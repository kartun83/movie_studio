using com.kartun.movie_studio as M from '../../../db/schema';
using { Currency, cuid } from '@sap/cds/common';

service BudgetService @(requires: 'authenticated-user'){

//   entity Movies as projection on M.MovieProject;
  entity Assets as projection on M.Asset;
  entity Expenses as projection on M.Expense;
  entity Contracts as projection on M.Contract;
  entity Distributions as projection on M.DistributionRight;
  entity Locations as projection on M.Location;

  function getTotalBudgetForGenre@(requires: 'FinancialAnalyst')(
    genre : M.GenreType:code
  ) returns {
    count : Integer;
    total : Decimal(15,2);
    avg : Decimal(15,2);
  }

  function getTotalBudgetForStatus @(requires: 'FinancialAnalyst')(
    status : M.ProjectStatus:code
  ) returns Decimal(15,2);

  function getTotalBudgetForMovie @(requires: 'FinancialAnalyst')(
    movie : M.MovieProject:ID
  ) returns Decimal(15,2);
}

annotate BudgetService.Expenses with @odata.draft.enabled;
annotate BudgetService.Expenses with @fiori.draft.enabled;