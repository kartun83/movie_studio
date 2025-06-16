namespace com.kartun.movie_studio;

using { cuid, managed } from '@sap/cds/common';
using { com.kartun.movie_studio.ContractType } from '../codelists';
using { com.kartun.movie_studio.Person } from './person';
using { com.kartun.movie_studio.MovieProject } from './movie';

entity Contract : cuid, managed {
  person    : Association to Person;
  movie     : Association to MovieProject;
  type      : Association to ContractType;
  startDate : Date;
  endDate   : Date;
  terms     : String(1000);
}
