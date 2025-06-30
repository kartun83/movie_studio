namespace com.kartun.movie_studio;

using { cuid, managed } from '@sap/cds/common';
using { com.kartun.movie_studio.Department } from '../codelists';
using { com.kartun.movie_studio.MovieProject } from './movie';
using { com.kartun.movie_studio.Person } from './person';
using { com.kartun.movie_studio.PersonRole } from '../codelists';

entity CrewAssignment : cuid, managed {
  movie           : Association to MovieProject;
  person          : Association to Person;
  department      : Association to Department;
  role            : Association to PersonRole;
}
