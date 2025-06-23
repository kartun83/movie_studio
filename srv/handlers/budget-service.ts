import cds from '@sap/cds';
// import { getTransaction, SELECT } from './base-service';

interface MovieProject {
    budget?: number;
    genre_primary?: { code: string };
    status_code?: string;
}

interface BudgetStats {
    count: number;
    total: number;
    avg: number;
}

export default class BudgetService extends cds.ApplicationService {
    async init() {
        await super.init();
        
        this.on('getTotalBudget', this.getTotalBudget);
        this.on('getBudgetStatsFor', this.getBudgetStatsFor);
    }

    private async getTotalBudget(req: cds.Request) {
        const genre = req.params[0] as string;
        const tx = cds.transaction(req);

        const result = await tx.run(
            SELECT.from('MovieProject')
                .where({ 'genre_primary.code': genre })
                .columns('sum(budget) as total')
        );

        return result[0]?.total || 0;
    }

    private async getBudgetStatsFor(req: cds.Request): Promise<BudgetStats> {
        const { status } = req.data as { status: string };
        const tx = cds.transaction(req);

        const query = SELECT
            .columns([
                'count(*) as count',
                'sum(budget) as total',
                'avg(budget) as avg'
            ])
            .from('MovieProject')
            .where({ status_code: status });

        const result = await tx.run(query);
        return result[0] || { count: 0, total: 0, avg: 0 };
    }
}

module.exports = BudgetService;