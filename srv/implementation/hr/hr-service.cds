using com.kartun.movie_studio as M from '../../../db/schema';

service HRService @(path: '/hr') {
    entity Person as projection on M.Person {
        ID,
        firstName,
        lastName,
        role,
        birthDate,
        agency,
        contactInfo,
        country,
        fullName,
        // virtual fullName : String,        
    };
    entity Contract as projection on M.Contract;
    entity PersonRole as projection on M.PersonRole;
}

annotate HRService.Person with @(odata.draft.enabled:true, fiori.draft.enabled:true);