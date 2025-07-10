import cds from '@sap/cds';

export default class PersonService extends cds.ApplicationService {
    async init() {
    
        await super.init();
        this.on('getFullName', this.getFullName);
    }

    async getFullName(req: cds.Request): Promise<string> {
        const { firstName, lastName } = req.data;
        return `${firstName} ${lastName}`;
    }
}

module.exports = PersonService;