namespace com.kartun.movie_studio;

using { com.kartun.movie_studio.Expense } from '../core/expense';
using { com.kartun.movie_studio.CrewAssignment } from '../core/crew';
using { com.kartun.movie_studio.Department } from '../codelists';
using { com.kartun.movie_studio.Asset } from '../core/asset';
using { com.kartun.movie_studio.AssetType } from '../codelists';

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