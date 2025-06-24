namespace com.kartun.movie_studio;

using { cuid, managed } from '@sap/cds/common';
using { com.kartun.movie_studio.AssetType, com.kartun.movie_studio.AssetStatus } from '../codelists';
using { com.kartun.movie_studio.MovieProject } from './movie';
using { com.kartun.movie_studio.Location } from './location';

entity Asset : cuid, managed {
  movie    : Association to one MovieProject @nullable; // 0..1 cardinality
  type     : Association to AssetType @assert.notNull @assert.integrity;  
  name     : String(100) @assert.notNull;
  status   : Association to AssetStatus @assert.notNull @assert.integrity;
  location : Association to Location @assert.notNull @assert.integrity;
}
