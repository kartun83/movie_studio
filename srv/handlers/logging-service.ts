import cds from '@sap/cds';

export default class LoggingService extends cds.ApplicationService {
    async init() {
        // Register handlers for all entities and custom events
        this.before(['CREATE', 'UPDATE', 'DELETE'], '*', this.logBeforeEvent);
        this.after(['CREATE', 'READ', 'UPDATE', 'DELETE'], '*', this.logAfterEvent);
        this.on('*', this.logCustomEvents);
        this.on('error', this.logErrors);

        // Log service initialization
        console.log('LoggingService initialized');

        await super.init();
    }

    private logBeforeEvent(req: cds.Request) {
        const { event, entity, data, params, query, user } = req;
        console.debug('=== BEFORE EVENT ===');
        console.debug(`Event: ${event}`);
        console.debug(`Entity: ${entity}`);
        console.debug(`User: ${user?.id || 'anonymous'}`);
        
        if (data) console.debug('Data:', JSON.stringify(data, null, 2));
        if (params) console.debug('Params:', JSON.stringify(params, null, 2));
        if (query) console.debug('Query:', JSON.stringify(query, null, 2));
    }

    private logAfterEvent(results: any, req: cds.Request) {
        const { event, entity } = req;
        console.debug('=== AFTER EVENT ===');
        console.debug(`Event: ${event}`);
        console.debug(`Entity: ${entity}`);
        
        if (results !== undefined) {
            console.debug('Results:', JSON.stringify(results, null, 2));
        }
    }

    private logCustomEvents(req: cds.Request) {
        const { event, entity, data, params, user } = req;
        console.debug('=== CUSTOM EVENT ===');
        console.debug(`Event: ${event}`);
        if (entity) console.debug(`Entity: ${entity}`);
        console.debug(`User: ${user?.id || 'anonymous'}`);
        
        if (data) console.debug('Data:', JSON.stringify(data, null, 2));
        if (params) console.debug('Params:', JSON.stringify(params, null, 2));
    }

    private logErrors(err: Error, req: cds.Request) {
        console.error('=== ERROR ===');
        console.error(`Timestamp: ${new Date().toISOString()}`);
        
        if (req) {
            const { event, entity, user } = req;
            console.error(`Event: ${event}`);
            if (entity) console.error(`Entity: ${entity}`);
            console.error(`User: ${user?.id || 'anonymous'}`);
        }
        
        console.error('Error:', err.message);
        console.error('Stack:', err.stack);
    }
}

module.exports = LoggingService;