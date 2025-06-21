namespace com.kartun.movie_studio;

using { cuid, managed, Country, Language } from '@sap/cds/common';
using { com.kartun.movie_studio.PersonRole } from '../codelists';

entity Person : cuid, managed {
  name        : String(100);
  role        : Association to PersonRole;
  birthDate   : Date; 
  agency      : String(100); @nullable
  contactInfo : many ContactInfo;
//   contactInfo : array of  ContactInfo;
  country     : Country;
  language    : many Language;
}

type ContactInfo : {
  kind    : String;
  address : String;
}
