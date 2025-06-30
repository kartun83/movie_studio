namespace com.kartun.movie_studio;

using { cuid, managed, Country } from '@sap/cds/common';
using { com.kartun.movie_studio.PersonRole } from '../codelists';

entity Person : cuid, managed {
  name        : String(100);
  role        : Association to PersonRole;
  birthDate   : Date; 
  agency      : String(100); @nullable
  contactInfo : many ContactInfo;
//   contactInfo : array of  ContactInfo;
  country     : Country;
  languages   : Composition of many Language on languages.person = $self;
}

entity Language : cuid, managed {
  code    : String(10);
  name    : String(100);
  person  : Association to Person;
}

type ContactInfo : {
  kind    : String;
  address : String;
}
