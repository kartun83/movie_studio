namespace com.kartun.movie_studio;

using { cuid, managed } from '@sap/cds/common';
using { com.kartun.movie_studio.AssetType, com.kartun.movie_studio.AssetStatus } from '../codelists';
using { com.kartun.movie_studio.MovieProject } from './movie';

entity Asset : cuid, managed {
  movie    : Association to one MovieProject; // 0..1 cardinality
  type     : Association to AssetType;
  name     : String(100);
  status   : Association to AssetStatus;
  location : String(255);
}
