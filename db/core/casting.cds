namespace com.kartun.movie_studio;

using { cuid, managed } from '@sap/cds/common';
using { com.kartun.movie_studio.MovieProject } from './movie';
using { com.kartun.movie_studio.Person } from './person';

entity Casting : cuid, managed {
  movie         : Association to MovieProject @assert.notNull;
  person        : Association to Person @assert.notNull;
  characterName : String(100) @assert.notNull;
  isLeadRole    : Boolean @assert.notNull;
}
