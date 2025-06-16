namespace com.kartun.movie_studio;

using { cuid, managed } from '@sap/cds/common';
using { com.kartun.movie_studio.MovieProject } from './movie';
using { com.kartun.movie_studio.Person } from './person';

entity Casting : cuid, managed {
  movie         : Association to MovieProject;
  person        : Association to Person;
  characterName : String(100);
  isLeadRole    : Boolean;
}
