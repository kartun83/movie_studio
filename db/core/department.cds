namespace com.kartun.movie_studio;

using { cuid, managed } from '@sap/cds/common';
using { com.kartun.movie_studio.Department, com.kartun.movie_studio.ProjectStatus } from '../codelists';

// Defines which departments are allowed in which statuses
entity DepartmentStatusRule : cuid, managed {
  status : Association to ProjectStatus;
  department : Association to Department;
  isAllowed : Boolean default true;
  notes : String(500);
}

// Alternative if you want to define allowed departments per status
entity StatusDepartment : cuid, managed {
  status : Association to ProjectStatus;
  allowedDepartment : Association to Department;
}