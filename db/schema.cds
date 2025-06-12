namespace com.kartun.movie_studio;
using { cuid, managed, sap.common.CodeList } from '@sap/cds/common';

// --- CodeLists with i18n support ---
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

// --- Core Domain Entities ---

entity MovieProject : managed, cuid {
      title        : String(200);
      status       : Association to ProjectStatus;
      releaseDate  : Date;
      budget       : Decimal(15,2);
      genre        : String(100);
      director     : Association to Person;
}

entity Person : managed, cuid {
      name         : String(100);
      role         : Association to PersonRole;
      birthDate    : Date;
      agency       : String(100);
      contactInfo  : String(255);
}

entity Casting : managed, cuid {
      movie        : Association to MovieProject;
      person       : Association to Person;
      characterName: String(100);
      isLeadRole   : Boolean;
}

entity CrewAssignment : managed, cuid {
      movie        : Association to MovieProject;
      person       : Association to Person;
      department   : Association to Department;
      roleDescription : String(100);
}

entity Location : managed, cuid {
      name         : String(100);
      address      : String(255);
      contactPerson: String(100);
      availability : Association to AvailabilityStatus;
}

entity Asset : managed, cuid {
      movie        : Association to MovieProject;
      type         : Association to AssetType;
      name         : String(100);
      status       : Association to AssetStatus;
      location     : String(255);
}

entity Expense : managed, cuid {
      movie        : Association to MovieProject;
      category     : Association to ExpenseCategory;
      amount       : Decimal(15,2);
      date         : Date;
      description  : String(255);
}

entity Contract : managed, cuid {
      person       : Association to Person;
      movie        : Association to MovieProject;
      type         : Association to ContractType;
      startDate    : Date;
      endDate      : Date;
      terms        : String(1000);
}

entity DistributionRight : managed, cuid {
      movie        : Association to MovieProject;
      region       : String(100);
      platform     : Association to PlatformType;
      startDate    : Date;
      endDate      : Date;
}

entity FileAttachment : managed, cuid {
      entity       : String(100);
      entity_ID    : UUID;
      fileName     : String(255);
      mimeType     : String(100);
      url          : String(500);
}

entity ProductionStatusLog : managed, cuid {
      movie        : Association to MovieProject;
      status       : Association to ProjectStatus;
      timestamp    : DateTime;
      comment      : String(500);
}
