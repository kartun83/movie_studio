namespace com.kartun.movie_studio;

using { cuid, managed } from '@sap/cds/common';
using { com.kartun.movie_studio.Person } from './person';
// using { com.kartun.movie_studio.LocationAvailabilityStatus } from '../codelists';
using { com.kartun.movie_studio.LocationType } from '../codelists';

entity Location : cuid, managed {
  name           : String(100);
  address        : String(255);
  contactPerson  : Association to Person @assert.notNull;
  locationtype   : Association to LocationType @assert.notNull;
  // availability   : Association to LocationAvailabilityStatus;
}
