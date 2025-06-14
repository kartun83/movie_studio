namespace com.kartun.movie_studio;
using { cuid, managed, sap.common.CodeList, Currency, Country, Language } from '@sap/cds/common';

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

@cds.odata.valuelist
entity GenreType : CodeList {
  key code : String(30);
      name : localized String(100);
}

type ContactInfo : {
      kind:String;
      address:String;
}
// type EmailAddress : String @assert.format: 'email';

// --- Core Domain Entities ---

entity MovieProject : cuid, managed {
      title        : String(200);
      status       : Association to ProjectStatus;
      releaseDate  : Date;
      budget       : Decimal(15,2);
      currency     : Currency;
      genre_primary: Association to GenreType;
      genre_secondary: many GenreType;
      director      : Association to Person;
      expenses      : Association to many Expense on expenses.movie = $self;
      castings      : Association to many Casting on castings.movie = $self;
      crewAssignments : Association to many CrewAssignment on crewAssignments.movie = $self;
      distributionRights : Association to many DistributionRight on distributionRights.movie = $self;
      assets        : Association to many Asset on assets.movie = $self;
      contracts     : Association to many Contract on contracts.movie = $self;
      productionStatusLogs : Association to many ProductionStatusLog on productionStatusLogs.movie = $self;
      // fileAttachments : Association to many FileAttachment on fileAttachments.entity_ID = $self;
}

entity Person : cuid, managed {
      name         : String(100);
      role         : Association to PersonRole;
      birthDate    : Date;
      agency       : String(100);
      // contactInfo  : String(255);
      contactInfo  : many ContactInfo;
      country      : Country;
      language     : Language;
      // Keywords many and array of are mere syntax variants with identical semantics and implementations.
      // emails  : many { kind:String; address:EmailAddress; };
}

entity Casting : cuid, managed {
      movie        : Association to MovieProject;
      person       : Association to Person;
      characterName: String(100);
      isLeadRole   : Boolean;
}

entity CrewAssignment : cuid, managed {
      movie        : Association to MovieProject;
      person       : Association to Person;
      department   : Association to Department;
      roleDescription : String(100);
}

entity Location : cuid, managed {
      name         : String(100);
      address      : String(255);
      contactPerson: String(100);
      availability : Association to AvailabilityStatus;
}

entity Asset : cuid, managed {
      movie        : Association to MovieProject;
      type         : Association to AssetType;
      name         : String(100);
      status       : Association to AssetStatus;
      location     : String(255);
}

entity Expense : cuid, managed {
      movie        : Association to MovieProject;
      category     : Association to ExpenseCategory;
      amount       : Decimal(15,2);
      currency     : Currency;
      date         : Date;
      description  : String(255);
}

entity Contract : cuid, managed {
      person       : Association to Person;
      movie        : Association to MovieProject;
      type         : Association to ContractType;
      startDate    : Date;
      endDate      : Date;
      terms        : String(1000);
}

entity DistributionRight : cuid, managed {
      movie        : Association to MovieProject;
      region       : String(100);
      platform     : Association to PlatformType;
      startDate    : Date;
      endDate      : Date;
}

entity FileAttachment : cuid, managed {
      entity       : String(100);
      entity_ID    : UUID;
      fileName     : String(255);
      mimeType     : String(100);
      url          : String(500);
}

entity ProductionStatusLog : cuid, managed {
      movie        : Association to MovieProject;
      status       : Association to ProjectStatus;
      timestamp    : DateTime;
      comment      : String(500);
}

// --- View and Projection ---

// View: Total Expense per Movie
view ExpenseSummary as select from Expense {
  movie.ID as movie_ID,
  sum(amount) as totalAmount
} group by movie.ID;

view ExpenseSummaryByDepartment as select from Expense
    inner join CrewAssignment on Expense.movie.ID = CrewAssignment.movie.ID
    inner join Department on CrewAssignment.department.code = Department.code
{
    Expense.movie.ID as movie,
    Department.name as department,
    sum(Expense.amount) as total
}
group by Expense.movie.ID, Department.name;

view ExpenseSummaryByAssetType as select from Expense
    inner join Asset on Expense.movie.ID = Asset.movie.ID
    inner join AssetType on Asset.type.code = AssetType.code
{
    Expense.movie.ID as movie,
    AssetType.name as assetType,
    sum(Expense.amount) as total
}
group by Expense.movie.ID, AssetType.name;

entity MinimalMovieInfo as projection on MovieProject {
  ID,
  title,
  status,
  releaseDate
}
