# CDS Service Logging Integration Guide

## Overview
This guide explains how to integrate comprehensive logging into all your CDS services using the provided logging utilities.

## Architecture

### 1. LoggingUtils (`logging-utils.ts`)
- **Singleton pattern** for consistent logging across all services
- **Configurable log levels** (debug, info, warn, error)
- **Structured logging** with context information
- **Performance monitoring** capabilities

### 2. BaseService (`base-service.ts`)
- **Abstract base class** that all services can extend
- **Automatic logging setup** for all CRUD operations
- **Helper methods** for business rule and validation logging
- **Performance timing** utilities

## Integration Steps

### Step 1: Update Service Class Declaration

**Before:**
```typescript
import cds from '@sap/cds';

export default class YourService extends cds.ApplicationService {
  async init() {
    // Your initialization code
    await super.init();
  }
}
```

**After:**
```typescript
import cds from '@sap/cds';
import { BaseService } from '../logging/base-service';

export default class YourService extends BaseService {
  constructor() {
    super('YourService'); // Service name for logging
  }

  async init() {
    // Your initialization code
    await super.init();
  }
}
```

### Step 2: Add Business Rule Logging

**Example - Validation:**
```typescript
private async validateData(req: cds.Request) {
  // Log the business rule being applied
  this.logBusinessRule('YourEntity', 'Data validation', { 
    field: 'title', 
    value: req.data.title 
  });
  
  // Perform validation
  if (!req.data.title) {
    this.logValidation('YourEntity', 'title', req.data.title, false);
    req.error(400, 'Title is required');
    return;
  }
  
  this.logValidation('YourEntity', 'title', req.data.title, true);
}
```

### Step 3: Add Performance Monitoring

**Example - Database Operations:**
```typescript
private async getData(req: cds.Request) {
  return await this.timeOperation('get_data', 'YourEntity', async () => {
    return await cds.read('YourEntity').where({ id: req.data.id });
  });
}
```

### Step 4: Add Custom Event Logging

**Example - Custom Actions:**
```typescript
private async customAction(req: cds.Request) {
  this.logBusinessRule('YourEntity', 'Custom action executed', {
    action: 'customAction',
    params: req.data
  });
  
  // Your action logic
  const result = await this.timeOperation('custom_action', 'YourEntity', async () => {
    // Action implementation
    return { success: true };
  });
  
  return result;
}
```

## Complete Integration Example

Here's a complete example of how to integrate logging into a service:

```typescript
import cds from '@sap/cds';
import { BaseService } from '../logging/base-service';

export default class ExampleService extends BaseService {
  constructor() {
    super('ExampleService');
  }

  async init() {
    // Register your handlers
    this.before('CREATE', 'ExampleEntity', this.validateCreate);
    this.before('UPDATE', 'ExampleEntity', this.validateUpdate);
    this.after('CREATE', 'ExampleEntity', this.logCreated);
    
    await super.init();
  }

  private async validateCreate(req: cds.Request) {
    this.logBusinessRule('ExampleEntity', 'Create validation', {
      data: req.data,
      user: req.user?.id
    });

    // Validate required fields
    if (!req.data.name) {
      this.logValidation('ExampleEntity', 'name', req.data.name, false);
      req.error(400, 'Name is required');
      return;
    }

    this.logValidation('ExampleEntity', 'name', req.data.name, true);
  }

  private async validateUpdate(req: cds.Request) {
    this.logBusinessRule('ExampleEntity', 'Update validation', {
      id: req.data.ID,
      changes: req.data
    });

    // Check if entity exists
    const existing = await this.timeOperation('read_existing', 'ExampleEntity', async () => {
      return await cds.read('ExampleEntity').where({ ID: req.data.ID });
    });

    if (!existing || existing.length === 0) {
      this.logValidation('ExampleEntity', 'exists', req.data.ID, false);
      req.error(404, 'Entity not found');
      return;
    }

    this.logValidation('ExampleEntity', 'exists', req.data.ID, true);
  }

  private async logCreated(data: any, req: cds.Request) {
    this.logBusinessRule('ExampleEntity', 'Entity created successfully', {
      id: data.ID,
      name: data.name,
      user: req.user?.id
    });
  }
}
```

## Log Output Examples

### Business Rule Log
```
[2025-07-09T22:45:30.123Z] [ExampleService] [ExampleEntity] [user123] Business Rule: Create validation
Data: {
  "data": {
    "name": "Test Entity",
    "description": "Test description"
  },
  "user": "user123"
}
```

### Validation Log
```
[2025-07-09T22:45:30.124Z] [ExampleService] [ExampleEntity] [user123] Validation: name = Test Entity (PASS)
```

### Performance Log
```
[2025-07-09T22:45:30.125Z] [ExampleService] [ExampleEntity] [user123] Performance: read_existing took 45ms
```

### Error Log
```
[2025-07-09T22:45:30.126Z] [ExampleService] [ExampleEntity] [user123] === ERROR ===
Timestamp: 2025-07-09T22:45:30.126Z
Event: CREATE
Entity: ExampleEntity
User: user123
Error: Validation failed
Stack: Error: Validation failed
    at validateCreate (/path/to/service.ts:25:15)
```

## Configuration Options

### Log Level Configuration
```typescript
import { logger } from './logging-utils';

// Set log level (debug, info, warn, error)
logger.setLogLevel('debug'); // Most verbose
logger.setLogLevel('info');  // Default
logger.setLogLevel('warn');  // Only warnings and errors
logger.setLogLevel('error'); // Only errors
```

### Environment-Based Configuration
```typescript
// In your service initialization
if (process.env.NODE_ENV === 'development') {
  logger.setLogLevel('debug');
} else {
  logger.setLogLevel('info');
}
```

## Best Practices

### 1. Consistent Naming
- Use descriptive service names
- Use consistent entity names
- Use meaningful business rule descriptions

### 2. Appropriate Log Levels
- **DEBUG**: Detailed information for debugging
- **INFO**: General information about operations
- **WARN**: Warning conditions
- **ERROR**: Error conditions

### 3. Performance Monitoring
- Use `timeOperation` for database queries
- Use `timeOperation` for external API calls
- Monitor business logic execution time

### 4. Security Considerations
- Don't log sensitive data (passwords, tokens)
- Be careful with PII (Personally Identifiable Information)
- Consider data retention policies

### 5. Error Handling
- Always log errors with context
- Include stack traces for debugging
- Log both the error and the request context

## Migration Checklist

For each service, ensure you have:

- [ ] Extended `BaseService` instead of `cds.ApplicationService`
- [ ] Added constructor with service name
- [ ] Called `super.init()` in the `init()` method
- [ ] Added business rule logging for validations
- [ ] Added performance monitoring for database operations
- [ ] Added custom event logging for business actions
- [ ] Configured appropriate log levels
- [ ] Tested logging output in development

## Troubleshooting

### Common Issues

1. **Missing service name**: Ensure you pass a service name to the BaseService constructor
2. **Log level not working**: Check that you're calling `logger.setLogLevel()` before any logging
3. **Performance timing issues**: Ensure you're using `timeOperation` correctly with async functions
4. **Context missing**: Make sure you're providing all required context information

### Debug Tips

1. **Check log output**: Verify logs are appearing in the console
2. **Test log levels**: Try different log levels to see what information is available
3. **Monitor performance**: Use the performance logs to identify slow operations
4. **Validate context**: Ensure all logged context information is accurate

## Additional Resources

- [CDS Documentation](https://cap.cloud.sap/docs/)
- [Node.js Console API](https://nodejs.org/api/console.html)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/) 