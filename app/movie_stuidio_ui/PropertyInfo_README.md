# PropertyInfo Validation Guide for UI5 Fiori Elements

## Overview
This guide explains how to resolve the PropertyInfo validation warning that appears in UI5 Fiori Elements applications, specifically for FilterBar controls.

## The Warning
```
[FUTURE FATAL] PropertyInfo validation is disabled for control com.kartun.movie_studio::MoviesList--fe::FilterBar::Movies. 
Migrate this control's propertyInfo to avoid breaking changes in the future
```

## Root Cause
The warning occurs because:
1. The FilterBar control lacks proper PropertyInfo configuration
2. UI5 is planning to enforce stricter validation in future versions
3. The current configuration doesn't explicitly define which properties should be available for filtering

## Solution Implemented

### 1. Added SelectionFields Annotation
The `SelectionFields` annotation defines which fields should be available in the FilterBar:

```cds
annotate MovieService.Movies with @(
    UI:{
        // ... other annotations ...
        SelectionFields: [
            title,
            budget,
            releaseDate,
            status
        ]
    }
)
```

### 2. Enhanced Property Annotations
Each property now has proper Common annotations for better UI integration:

```cds
annotate MovieService.Movies with{
    title @title: 'Movie Title' @(
        Common: {
            Text: title,
            Label: 'Title'
        }
    );
    budget @title: 'Budget' @(
        Common: {
            Text: 'Budget',
            Label: 'Budget'
        }
    );
    // ... other properties
}
```

## Key Configuration Points

### 1. SelectionFields Annotation
- **Purpose**: Defines which fields appear in the FilterBar
- **Syntax**: Array of property names
- **Example**: `SelectionFields: [title, budget, releaseDate, status]`

### 2. Common Annotations
- **Text**: Provides display text for the property
- **Label**: Provides label text for UI controls
- **Usage**: Use property paths for string fields, string literals for non-string fields

### 3. Property Types
- **String fields**: Can use property paths in Common.Text
- **Numeric fields**: Use string literals in Common.Text
- **Date fields**: Use string literals in Common.Text
- **Association fields**: Use string literals in Common.Text

## Best Practices

### 1. PropertyInfo Structure
```cds
// ✅ Correct - String field with property path
title @(
    Common: {
        Text: title,
        Label: 'Title'
    }
)

// ✅ Correct - Non-string field with string literal
budget @(
    Common: {
        Text: 'Budget',
        Label: 'Budget'
    }
)

// ❌ Incorrect - Non-string field with property path
budget @(
    Common: {
        Text: budget,  // Will cause validation error
        Label: 'Budget'
    }
)
```

### 2. SelectionFields Configuration
```cds
// ✅ Correct - Simple property names
SelectionFields: [
    title,
    budget,
    releaseDate,
    status
]

// ✅ Correct - With navigation properties
SelectionFields: [
    title,
    status/code,
    status/name
]
```

### 3. FilterBar Behavior
- **String fields**: Support substring search
- **Numeric fields**: Support range filters
- **Date fields**: Support date range filters
- **Association fields**: Support exact match filters

## Migration Steps

### Step 1: Identify FilterBar Controls
Look for controls with names like:
- `{appName}::{pageName}--fe::FilterBar::{entityName}`
- `{appName}::{pageName}--fe::FilterBar`

### Step 2: Add SelectionFields
Add the `SelectionFields` annotation to your entity:

```cds
annotate YourService.YourEntity with @(
    UI:{
        SelectionFields: [
            // List your filterable fields here
            field1,
            field2,
            field3
        ]
    }
)
```

### Step 3: Enhance Property Annotations
Add proper Common annotations to each property:

```cds
annotate YourService.YourEntity with{
    field1 @(
        Common: {
            Text: field1,  // For string fields
            Label: 'Field 1'
        }
    );
    field2 @(
        Common: {
            Text: 'Field 2',  // For non-string fields
            Label: 'Field 2'
        }
    );
}
```

### Step 4: Test the Configuration
1. Deploy your CAP service
2. Restart your UI5 application
3. Check that the FilterBar appears correctly
4. Verify that filtering works as expected

## Troubleshooting

### Common Issues

1. **Validation Errors**
   - Ensure property paths are correct
   - Use string literals for non-string fields
   - Check that all referenced properties exist

2. **FilterBar Not Appearing**
   - Verify SelectionFields annotation is present
   - Check that properties are accessible
   - Ensure proper UI5 model configuration

3. **Filtering Not Working**
   - Verify property annotations are correct
   - Check OData service configuration
   - Ensure proper data types

### Debug Tips

1. **Check Browser Console**
   - Look for PropertyInfo-related errors
   - Verify annotation loading

2. **Validate Annotations**
   - Use CAP annotation validation
   - Check CDS syntax

3. **Test Incrementally**
   - Add one field at a time
   - Test filtering after each addition

## Additional Resources

- [SAP Fiori Elements Documentation](https://sapui5.hana.ondemand.com/#/topic/03265b0408e2432c9571d6b3feb6b1fd)
- [UI Vocabulary Reference](https://sapui5.hana.ondemand.com/#/topic/4527729576cb4a4888275b693c7fc87f)
- [Common Vocabulary Reference](https://sapui5.hana.ondemand.com/#/topic/4527729576cb4a4888275b693c7fc87f)

## Future Considerations

1. **UI5 Version Updates**: PropertyInfo validation will become stricter
2. **Performance**: Proper PropertyInfo configuration improves filtering performance
3. **Accessibility**: Better annotations improve screen reader support
4. **Maintenance**: Clear PropertyInfo makes code more maintainable 