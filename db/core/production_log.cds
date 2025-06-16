namespace com.kartun.movie_studio;

using { cuid, managed } from '@sap/cds/common';
using { com.kartun.movie_studio.ProjectStatus } from '../codelists';
using { com.kartun.movie_studio.MovieProject } from './movie';

entity ProductionStatusLog : cuid, managed {
  movie     : Association to MovieProject;
  status    : Association to ProjectStatus;
  timestamp : DateTime;
  comment   : String(500);
}
