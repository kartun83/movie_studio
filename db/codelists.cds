namespace com.kartun.movie_studio;

using { sap.common.CodeList } from '@sap/cds/common';

@cds.odata.valuelist
entity ProjectStatus : CodeList {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity PersonRole : CodeList {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity Department : CodeList {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity AssetType : CodeList {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity AssetStatus : CodeList {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity AvailabilityStatus : CodeList {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity ExpenseCategory : CodeList {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity ContractType : CodeList {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity PlatformType : CodeList {
  key code : String(30);
      name : localized String(100);
}

@cds.odata.valuelist
entity GenreType : CodeList {
  key code : String(30);
      name : localized String(100);
}
