namespace com.kartun.movie_studio;

using { cuid, managed, Currency } from '@sap/cds/common';
using { com.kartun.movie_studio.ExpenseCategory } from '../codelists';
using { com.kartun.movie_studio.MovieProject } from './movie';

entity Expense : cuid, managed {
  movie       : Association to MovieProject;
  category    : Association to ExpenseCategory;
  amount      : Decimal(15,2);
  currency    : Currency;
  date        : Date;
  description : String(255);
}
