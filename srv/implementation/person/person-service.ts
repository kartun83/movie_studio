import cds from '@sap/cds';

export default class PersonService extends cds.ApplicationService {
    async init() {
    
        
        this.before('*', console.log)
        this.on('getFullName', this.getFullName);
        this.on(['READ'],'fullName', this.getFullName2);
        return await super.init();
    }

    async getFullName(req: cds.Request): Promise<string> {
        console.log('get full name', req);
        const { firstName, lastName } = req.data;
        return `${firstName} ${lastName}`;
    }

    async getFullName2(person: any){
        console.log('get full name', person);
        return `${person.firstName} ${person.lastName}`;
    }

    // async getFullName2() {
    //     return `${this.firstName} ${this.lastName}`;
    // }
}

module.exports = PersonService;