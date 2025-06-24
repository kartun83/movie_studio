# AssetsService HTTP Tests

This directory contains comprehensive HTTP tests for the AssetsService.

## Test File: `assets-service.http`

This file contains tests for all AssetsService endpoints and business rules.

## Prerequisites

1. Make sure your CAP application is running on `http://localhost:4004`
2. Ensure the database is populated with test data (codelists, locations, etc.)
3. Use a REST client that supports HTTP files (VS Code REST Client, IntelliJ HTTP Client, etc.)

## Test Categories

### 1. Basic CRUD Operations
- GET metadata document
- GET all assets, statuses, types, and locations
- CREATE assets with valid data
- READ assets by ID
- UPDATE assets
- DELETE assets

### 2. Business Rules Testing
- **Rule 1**: RETIRED assets cannot be modified or deleted (403 error expected)
- **Rule 2**: Status transition rules:
  - AVAILABLE assets cannot have movie_ID
  - RESERVED assets must have movie_ID
  - When setting status to AVAILABLE, movie_ID is cleared

### 3. Function Testing
- `getAvailableAssets(type)` function with different asset types

### 4. OData Query Testing
- Filtering by status, type, location
- Expanding related entities
- Selecting specific fields
- Ordering and pagination

### 5. Draft Functionality Testing
- Creating drafts
- Activating drafts
- Editing drafts
- Discarding drafts

### 6. Error Handling Testing
- Invalid type codes
- Invalid status codes
- Invalid location IDs
- Missing required fields
- Null values for required fields

## Expected Results

### Successful Operations (200/201)
- Creating assets with valid data
- Reading assets and codelists
- Updating non-RETIRED assets
- Deleting non-RETIRED assets
- Function calls with valid parameters

### Business Rule Violations (400/403)
- Creating AVAILABLE assets with movie_ID (400)
- Creating RESERVED assets without movie_ID (400)
- Updating RETIRED assets (403)
- Deleting RETIRED assets (403)

### Validation Errors (400)
- Invalid foreign key references
- Missing required fields
- Null values for required fields

## Running the Tests

1. Open the `assets-service.http` file in your REST client
2. Execute tests individually or in sequence
3. Check response status codes and body content
4. Verify business rules are enforced correctly

## Test Data Dependencies

The tests use the following test data that should be available in your database:

### Asset Statuses
- AVAILABLE
- RESERVED
- IN_USE
- MAINTENANCE
- RETIRED

### Asset Types
- CAMERA
- LIGHT
- MIC
- COSTUME
- STAGE
- SOUND
- PROPS
- VEHICLE
- EQUIPMENT

### Locations
- Various location IDs from the Location entity

## Notes

- Tests use variables to capture IDs from successful creation operations
- Some tests depend on previous test results (using captured variables)
- The draft functionality tests require the `@odata.draft.enabled: true` annotation
- Error tests are designed to verify proper validation and business rule enforcement 