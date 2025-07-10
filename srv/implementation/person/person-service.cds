using com.kartun.movie_studio as M from '../../../db/schema';
// using { Currency, cuid } from '@sap/cds/common';

service PersonService {

  @odata.draft.enabled: true
  entity Persons as projection on M.Person {
    ID,
    lastName @assert.notNull,
    firstName @assert.notNull,
    role,
    birthDate,
    agency,
    contactInfo,
    country,
    languages
  }

  function getFullName(
    firstName : String,
    lastName : String
  ) returns String;
} 