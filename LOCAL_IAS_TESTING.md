# Local IAS Testing Guide

This guide explains how to test IAS integration locally with your CAP application.

## Testing Options

### Option 1: Mock IAS Testing (Recommended for Development)

Use mock authentication that simulates IAS behavior:

```bash
# Start with mock IAS
npm run start:ias
```

**Features:**
- ✅ Fast startup
- ✅ No external dependencies
- ✅ Predefined test users
- ✅ Simulates IAS user attributes
- ✅ Works offline

**Test Users Available:**
- `admin@test.com` - Admin role
- `assetmanager@test.com` - Asset Manager role
- `studiodirector@test.com` - Studio Director role
- `consultant@test.com` - Consultant role
- `financial@test.com` - Financial Analyst role

### Option 2: Real IAS Testing (Advanced)

Connect to actual IAS instance:

```bash
# Start with real IAS (requires IAS setup)
npm run start:ias-real
```

**Prerequisites:**
- IAS instance configured in Cloud Foundry
- XSUAA service configured with IAS trust
- Proper service bindings
- Network access to IAS

## Testing Scenarios

### 1. HTTP Testing with REST Client

Create test requests in your HTTP files:

```http
### Test as Admin User
GET {{baseUrl}}/assets/Assets
Authorization: Bearer admin@test.com

### Test as Asset Manager
GET {{baseUrl}}/assets/Assets
Authorization: Bearer assetmanager@test.com

### Test as Studio Director
GET {{baseUrl}}/movie/Movies
Authorization: Bearer studiodirector@test.com

### Test as Consultant
GET {{baseUrl}}/config/Genres
Authorization: Bearer consultant@test.com

### Test as Financial Analyst
GET {{baseUrl}}/movie/Expenses
Authorization: Bearer financial@test.com
```

### 2. Programmatic Testing

Test in your JavaScript/TypeScript files:

```javascript
// Test with specific IAS user
const result = await cats.tx({ user: "admin@test.com" }, () => {
  return cats.read(Assets);
});

// Test authorization restrictions
const result = await cats.tx({ user: "assetmanager@test.com" }, () => {
  return cats.create(Assets, {
    name: "Test Asset",
    type_code: "CAMERA",
    status_code: "AVAILABLE"
  });
});
```

### 3. Browser Testing

1. Start the application: `npm run start:ias`
2. Open browser to `http://localhost:4004`
3. Use browser developer tools to modify requests
4. Test different user contexts

## Configuration Files

### default-env.json
- Mock IAS service configuration
- Mock XSUAA service configuration
- Predefined test users with IAS origin
- Local development settings

### .cdsrc.json
- `ias` profile: Mock IAS with SQLite
- `ias-real` profile: Real IAS with HANA
- Development-friendly configurations

### package.json
- `start:ias`: Mock IAS testing
- `start:ias-real`: Real IAS testing

## Testing Authorization Rules

### Asset Management
```javascript
// Test AssetManager permissions
const assetManager = await cats.tx({ user: "assetmanager@test.com" }, () => {
  return cats.read(Assets);
});

// Test Admin permissions
const admin = await cats.tx({ user: "admin@test.com" }, () => {
  return cats.read(Assets);
});
```

### Movie Management
```javascript
// Test Studio Director permissions
const movies = await cats.tx({ user: "studiodirector@test.com" }, () => {
  return cats.read(Movies);
});
```

### Configuration Access
```javascript
// Test Consultant permissions
const config = await cats.tx({ user: "consultant@test.com" }, () => {
  return cats.read(Genres);
});
```

## Debugging Tips

### 1. Check User Context
```javascript
// Log user information
console.log('User:', req.user);
console.log('Scopes:', req.user.scopes);
console.log('Roles:', req.user.roles);
console.log('Origin:', req.user.origin);
```

### 2. Verify Authorization
```javascript
// Check if user has required scope
if (req.user.scopes.includes('$XSAPPNAME.AssetManager')) {
  // User has AssetManager permissions
}
```

### 3. Test Different Origins
```javascript
// Test IAS origin specifically
if (req.user.origin === 'ias') {
  // User authenticated via IAS
}
```

## Common Issues and Solutions

### Issue: Authentication Not Working
**Solution:**
- Check if `default-env.json` is loaded
- Verify mock user configuration
- Ensure correct profile is used

### Issue: Authorization Failures
**Solution:**
- Verify user has required scopes
- Check role assignments
- Review service annotations

### Issue: Database Connection
**Solution:**
- Use SQLite for local testing
- Ensure database is initialized
- Check model loading

## Best Practices

1. **Use Mock for Development**: Mock IAS is faster and more reliable for development
2. **Test All Roles**: Verify each user role works correctly
3. **Test Authorization**: Ensure proper access controls
4. **Use Real IAS for Integration**: Test with real IAS before production
5. **Document Test Cases**: Keep track of what you've tested

## Next Steps

1. **Start with Mock**: Use `npm run start:ias` for development
2. **Test All Scenarios**: Verify authorization rules work
3. **Set Up Real IAS**: Configure actual IAS for integration testing
4. **Deploy to Cloud**: Test in Cloud Foundry environment 