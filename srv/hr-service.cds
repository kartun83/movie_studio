using com.kartun.movie_studio as db from '../db/schema';

service HRService @(path: '/hr') {
    entity Person as projection on db.Person;
    entity Contract as projection on db.Contract;
    entity PersonRole as projection on db.PersonRole;
}