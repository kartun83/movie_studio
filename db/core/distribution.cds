namespace com.kartun.movie_studio;

using { cuid, managed } from '@sap/cds/common';
using { com.kartun.movie_studio.PlatformType } from '../codelists';
using { com.kartun.movie_studio.MovieProject } from './movie';

entity DistributionRight : cuid, managed {
  movie     : Association to MovieProject;
  region    : String(100);
  platform  : Association to PlatformType;
  startDate : Date;
  endDate   : Date;
}
