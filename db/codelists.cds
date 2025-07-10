namespace com.kartun.movie_studio;

using { sap.common.CodeList, managed } from '@sap/cds/common';

@cds.odata.valuelist
entity ProjectStatus : CodeList, managed  {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity PersonRole : CodeList, managed  {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity Department : CodeList, managed  {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity AssetType : CodeList, managed {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity AssetStatus : CodeList, managed {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity LocationAvailabilityStatus : CodeList, managed {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity LocationType : CodeList, managed {
  key code : String(30);
      isTechnical : Boolean default false; // ← Flag for internal/technical locations
      name : localized String(100);
}

@cds.odata.valuelist
entity ExpenseCategory : CodeList, managed {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity ContractType : CodeList, managed {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity PlatformType : CodeList, managed {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity GenreType : CodeList, managed {
  key code : String(30);
      name : localized String(100);
}
