import cds from '@sap/cds';
import { logger, LogContext } from './logging-utils';

export abstract class BaseService extends cds.ApplicationService {
  protected serviceName: string;

  constructor(serviceName: string) {
    super();
    this.serviceName = serviceName;
  }

  async init() {
    // Set up logging handlers
    this.setupLogging();
    
    // Log service initialization
    logger.info({
      service: this.serviceName,
      operation: 'INIT'
    }, `Service ${this.serviceName} initialized`);

    await super.init();
  }

  private setupLogging() {
    // Register logging handlers for all entities
    this.before(['CREATE', 'UPDATE', 'DELETE'], '*', this.logBeforeEvent.bind(this));
    this.after(['CREATE', 'READ', 'UPDATE', 'DELETE'], '*', this.logAfterEvent.bind(this));
    this.on('*', this.logCustomEvent.bind(this));
    this.on('error', this.logError.bind(this));
  }

  private logBeforeEvent(req: cds.Request) {
    logger.logBeforeEvent(req, this.serviceName);
  }

  private logAfterEvent(results: any, req: cds.Request) {
    logger.logAfterEvent(results, req, this.serviceName);
  }

  private logCustomEvent(req: cds.Request) {
    logger.logCustomEvent(req, this.serviceName);
  }

  private logError(error: Error, req: cds.Request) {
    logger.logError(error, req, this.serviceName);
  }

  // Helper methods for business logic logging
  protected logBusinessRule(entity: string, rule: string, details?: any) {
    const context: LogContext = {
      service: this.serviceName,
      entity: entity,
      operation: 'BUSINESS_RULE'
    };
    logger.logBusinessRule(context, rule, details);
  }

  protected logValidation(entity: string, field: string, value: any, result: boolean) {
    const context: LogContext = {
      service: this.serviceName,
      entity: entity,
      operation: 'VALIDATION'
    };
    logger.logValidation(context, field, value, result);
  }

  protected logPerformance(entity: string, operation: string, duration: number) {
    const context: LogContext = {
      service: this.serviceName,
      entity: entity,
      operation: 'PERFORMANCE'
    };
    logger.logPerformance(context, operation, duration);
  }

  // Helper method for timing operations
  protected async timeOperation<T>(operation: string, entity: string, fn: () => Promise<T>): Promise<T> {
    const startTime = Date.now();
    try {
      const result = await fn();
      const duration = Date.now() - startTime;
      this.logPerformance(entity, operation, duration);
      return result;
    } catch (error) {
      const duration = Date.now() - startTime;
      this.logPerformance(entity, `${operation}_ERROR`, duration);
      throw error;
    }
  }

  // Helper method for validation logging
  protected validateAndLog(entity: string, field: string, value: any, validator: (value: any) => boolean): boolean {
    const result = validator(value);
    this.logValidation(entity, field, value, result);
    return result;
  }
} 