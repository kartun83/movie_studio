using com.kartun.movie_studio as M from '../../../db/schema';

service HRService @(path: '/hr') {
    entity Person as projection on M.Person;
    entity Contract as projection on M.Contract;
    entity PersonRole as projection on M.PersonRole;
}