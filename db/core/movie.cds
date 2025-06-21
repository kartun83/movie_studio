namespace com.kartun.movie_studio;

using { cuid, managed, Currency } from '@sap/cds/common';
using { com.kartun.movie_studio.ProjectStatus, com.kartun.movie_studio.GenreType } from '../codelists';
using { com.kartun.movie_studio.Person } from './person';
using { com.kartun.movie_studio.Expense } from './expense';
using { com.kartun.movie_studio.Casting } from './casting';
using { com.kartun.movie_studio.CrewAssignment } from './crew';
using { com.kartun.movie_studio.DistributionRight } from './distribution';
using { com.kartun.movie_studio.Asset } from './asset';
using { com.kartun.movie_studio.Contract } from './contract';
using { com.kartun.movie_studio.ProductionStatusLog } from './production_log';


entity MovieProject : cuid, managed {
  title              : String(200);
  status             : Association to ProjectStatus;
  releaseDate        : Date;
  budget             : Decimal(15,2);
  currency           : Currency;
  genre_primary      : Association to GenreType;
  genre_secondary    : Association to many MovieGenreSecondary on genre_secondary.movie = $self;
  director           : Association to Person;
  expenses           : Association to many Expense on expenses.movie = $self;
  castings           : Association to many Casting on castings.movie = $self;
  crewAssignments    : Association to many CrewAssignment on crewAssignments.movie = $self;
  distributionRights : Association to many DistributionRight on distributionRights.movie = $self;
  assets             : Association to many Asset on assets.movie = $self;
  contracts          : Association to many Contract on contracts.movie = $self;
  productionStatusLogs : Association to many ProductionStatusLog on productionStatusLogs.movie = $self;
}

entity MovieGenreSecondary {
  movie : Association to MovieProject;
  genre : Association to GenreType;
}
