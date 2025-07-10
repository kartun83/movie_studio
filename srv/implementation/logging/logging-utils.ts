import cds from '@sap/cds';

export interface LogContext {
  service: string;
  entity?: string;
  event?: string;
  user?: string;
  operation?: string;
  data?: any;
  params?: any;
  query?: any;
  results?: any;
  error?: Error;
}

export class LoggingUtils {
  private static instance: LoggingUtils;
  private logLevel: 'debug' | 'info' | 'warn' | 'error' = 'info';

  private constructor() {}

  static getInstance(): LoggingUtils {
    if (!LoggingUtils.instance) {
      LoggingUtils.instance = new LoggingUtils();
    }
    return LoggingUtils.instance;
  }

  setLogLevel(level: 'debug' | 'info' | 'warn' | 'error') {
    this.logLevel = level;
  }

  private shouldLog(level: 'debug' | 'info' | 'warn' | 'error'): boolean {
    const levels = { debug: 0, info: 1, warn: 2, error: 3 };
    return levels[level] >= levels[this.logLevel];
  }

  private formatLogMessage(context: LogContext, message: string): string {
    const timestamp = new Date().toISOString();
    const service = context.service || 'Unknown';
    const entity = context.entity || 'Unknown';
    const user = context.user || 'anonymous';
    
    return `[${timestamp}] [${service}] [${entity}] [${user}] ${message}`;
  }

  debug(context: LogContext, message: string, data?: any) {
    if (this.shouldLog('debug')) {
      const logMessage = this.formatLogMessage(context, message);
      console.debug(logMessage);
      if (data) console.debug('Data:', JSON.stringify(data, null, 2));
    }
  }

  info(context: LogContext, message: string, data?: any) {
    if (this.shouldLog('info')) {
      const logMessage = this.formatLogMessage(context, message);
      console.info(logMessage);
      if (data) console.info('Data:', JSON.stringify(data, null, 2));
    }
  }

  warn(context: LogContext, message: string, data?: any) {
    if (this.shouldLog('warn')) {
      const logMessage = this.formatLogMessage(context, message);
      console.warn(logMessage);
      if (data) console.warn('Data:', JSON.stringify(data, null, 2));
    }
  }

  error(context: LogContext, message: string, error?: Error) {
    if (this.shouldLog('error')) {
      const logMessage = this.formatLogMessage(context, message);
      console.error(logMessage);
      if (error) {
        console.error('Error:', error.message);
        console.error('Stack:', error.stack);
      }
    }
  }

  // Convenience methods for common logging scenarios
  logBeforeEvent(req: cds.Request, serviceName: string) {
    const context: LogContext = {
      service: serviceName,
      entity: req.entity,
      event: req.event,
      user: req.user?.id,
      operation: 'BEFORE',
      data: req.data,
      params: req.params,
      query: req.query
    };

    this.debug(context, `=== BEFORE ${req.event} ===`);
    this.debug(context, `Event: ${req.event}`);
    this.debug(context, `Entity: ${req.entity}`);
    this.debug(context, `User: ${req.user?.id || 'anonymous'}`);
    
    if (req.data) this.debug(context, 'Request Data:', req.data);
    if (req.params) this.debug(context, 'Request Params:', req.params);
    if (req.query) this.debug(context, 'Request Query:', req.query);
  }

  logAfterEvent(results: any, req: cds.Request, serviceName: string) {
    const context: LogContext = {
      service: serviceName,
      entity: req.entity,
      event: req.event,
      user: req.user?.id,
      operation: 'AFTER',
      results: results
    };

    this.debug(context, `=== AFTER ${req.event} ===`);
    this.debug(context, `Event: ${req.event}`);
    this.debug(context, `Entity: ${req.entity}`);
    
    if (results !== undefined) {
      this.debug(context, 'Results:', results);
    }
  }

  logCustomEvent(req: cds.Request, serviceName: string) {
    const context: LogContext = {
      service: serviceName,
      entity: req.entity,
      event: req.event,
      user: req.user?.id,
      operation: 'CUSTOM',
      data: req.data,
      params: req.params
    };

    this.debug(context, `=== CUSTOM EVENT ===`);
    this.debug(context, `Event: ${req.event}`);
    if (req.entity) this.debug(context, `Entity: ${req.entity}`);
    this.debug(context, `User: ${req.user?.id || 'anonymous'}`);
    
    if (req.data) this.debug(context, 'Event Data:', req.data);
    if (req.params) this.debug(context, 'Event Params:', req.params);
  }

  logError(error: Error, req: cds.Request, serviceName: string) {
    const context: LogContext = {
      service: serviceName,
      entity: req?.entity,
      event: req?.event,
      user: req?.user?.id,
      operation: 'ERROR',
      error: error
    };

    this.error(context, `=== ERROR ===`);
    this.error(context, `Timestamp: ${new Date().toISOString()}`);
    
    if (req) {
      this.error(context, `Event: ${req.event}`);
      if (req.entity) this.error(context, `Entity: ${req.entity}`);
      this.error(context, `User: ${req.user?.id || 'anonymous'}`);
    }
    
    this.error(context, 'Error:', error);
  }

  logBusinessRule(context: LogContext, rule: string, details?: any) {
    this.info(context, `Business Rule: ${rule}`, details);
  }

  logValidation(context: LogContext, field: string, value: any, result: boolean) {
    this.debug(context, `Validation: ${field} = ${value} (${result ? 'PASS' : 'FAIL'})`);
  }

  logPerformance(context: LogContext, operation: string, duration: number) {
    this.info(context, `Performance: ${operation} took ${duration}ms`);
  }
}

// Export singleton instance
export const logger = LoggingUtils.getInstance(); 