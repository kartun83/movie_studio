using com.kartun.movie_studio as M from '../../../db/schema';
// using { Currency, cuid } from '@sap/cds/common';

service PersonService {

  @odata.draft.enabled: true
  entity Persons as projection on M.Person {
    ID,
    name @assert.notNull,
    role,
    birthDate,
    agency,
    contactInfo,
    country,
    language
  }

} 