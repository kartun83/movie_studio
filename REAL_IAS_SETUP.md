# Real IAS Setup for Local Testing

This guide explains how to configure your CAP application to use real IAS for local testing.

## Prerequisites

1. ✅ IAS instance created in Cloud Foundry
2. ✅ XSUAA service instance configured with IAS trust
3. ✅ Application deployed to Cloud Foundry at least once
4. ✅ Service keys generated for both services

## Step 1: Get Service Credentials

### Get XSUAA Service Key
```bash
# Get XSUAA service key
cf service-key movie_studio-auth movie_studio-auth-key

# Or create a new key if it doesn't exist
cf create-service-key movie_studio-auth movie_studio-auth-key
```

### Get IAS Service Key
```bash
# Get IAS service key
cf service-key movie_studio-ias movie_studio-ias-key

# Or create a new key if it doesn't exist
cf create-service-key movie_studio-ias movie_studio-ias-key
```

## Step 2: Configure Local Environment

### Option A: Use default-env-ias.json (Recommended)

1. Copy the service credentials to `default-env-ias.json`:
```json
{
  "VCAP_SERVICES": {
    "xsuaa": [
      {
        "name": "movie_studio-auth",
        "tags": ["xsuaa"],
        "credentials": {
          "clientid": "sb-movie_studio-auth!t12345",
          "clientsecret": "your-actual-client-secret",
          "url": "https://your-subaccount.authentication.us10.hana.ondemand.com",
          "identityzone": "your-identity-zone",
          "identityzoneid": "your-zone-id",
          "verificationkey": "-----BEGIN PUBLIC KEY-----\n...\n-----END PUBLIC KEY-----",
          "xsappname": "movie_studio"
        }
      }
    ],
    "identity": [
      {
        "name": "movie_studio-ias",
        "tags": ["identity"],
        "credentials": {
          "clientid": "sb-movie_studio-ias!t12345",
          "clientsecret": "your-actual-ias-secret",
          "url": "https://your-ias-tenant.accounts.ondemand.com",
          "identityzone": "your-ias-zone",
          "identityzoneid": "your-ias-zone-id"
        }
      }
    ]
  }
}
```

2. Start with real IAS:
```bash
npm run start:ias-real
```

### Option B: Use Environment Variables

Set environment variables before starting:

```bash
# Set XSUAA credentials
export VCAP_SERVICES='{
  "xsuaa": [{
    "name": "movie_studio-auth",
    "credentials": {
      "clientid": "your-client-id",
      "clientsecret": "your-client-secret",
      "url": "your-xsuaa-url"
    }
  }],
  "identity": [{
    "name": "movie_studio-ias", 
    "credentials": {
      "clientid": "your-ias-client-id",
      "clientsecret": "your-ias-secret",
      "url": "your-ias-url"
    }
  }]
}'

# Start application
npm run start:ias-real
```

## Step 3: Configure IAS Application

### 1. Access IAS Admin Console
- Go to your IAS tenant: `https://your-tenant.accounts.ondemand.com/admin`
- Login with your IAS admin credentials

### 2. Create Application
1. Navigate to **Applications & Resources** → **Applications**
2. Click **Create Application**
3. Choose **Custom Application**
4. Set application name: `movie_studio`

### 3. Configure OAuth 2.0
1. Go to **Trust** → **OAuth 2.0 Configuration**
2. Set **Redirect URIs**:
   ```
   http://localhost:4004/**
   https://your-app-url/**
   ```
3. Set **Grant Types**:
   - ✅ Authorization Code
   - ✅ Refresh Token
4. Set **Response Types**:
   - ✅ Code
5. Set **Token Validity**: 43200 (12 hours)
6. Set **Refresh Token Validity**: 2592000 (30 days)

### 4. Configure User Groups
1. Go to **Users & Groups** → **Groups**
2. Create groups that match your XSUAA scopes:
   - `AssetManager`
   - `Admin`
   - `StudioDirector`
   - `Consultant`
   - `FinancialAnalyst`

### 5. Assign Users to Groups
1. Go to **Users & Groups** → **Users**
2. Create test users or use existing ones
3. Assign users to appropriate groups

## Step 4: Configure XSUAA to Trust IAS

### Update XSUAA Service
```bash
# Update XSUAA with IAS trust configuration
cf update-service movie_studio-auth -c xs-security.json
```

### Verify Trust Configuration
```bash
# Check service configuration
cf service movie_studio-auth
```

## Step 5: Test Real IAS Integration

### 1. Start Application
```bash
npm run start:ias-real
```

### 2. Test Authentication Flow
1. Open browser to `http://localhost:4004`
2. You should be redirected to IAS login
3. Login with your IAS credentials
4. You should be redirected back to your application

### 3. Test API Calls
```bash
# Get access token from IAS
curl -X POST "https://your-ias-tenant.accounts.ondemand.com/oauth2/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password&username=your-username&password=your-password&client_id=your-client-id&client_secret=your-client-secret"

# Use token to call your API
curl -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  "http://localhost:4004/odata/v4/assets/Assets"
```

## Step 6: Troubleshooting

### Common Issues

#### Issue: "Invalid client" error
**Solution:**
- Check client ID and secret in `default-env-ias.json`
- Verify IAS application configuration
- Ensure redirect URIs are correct

#### Issue: "Invalid redirect URI" error
**Solution:**
- Add `http://localhost:4004/**` to IAS redirect URIs
- Check for typos in the URI

#### Issue: "User not found" error
**Solution:**
- Verify user exists in IAS
- Check user group assignments
- Ensure user is active

#### Issue: "Insufficient scope" error
**Solution:**
- Verify user is assigned to correct groups
- Check XSUAA scope configuration
- Ensure IAS groups map to XSUAA scopes

### Debug Commands

```bash
# Check service instances
cf services

# View service keys
cf service-key movie_studio-auth movie_studio-auth-key
cf service-key movie_studio-ias movie_studio-ias-key

# Check application logs
cf logs movie_studio --recent

# Test IAS connection
curl -I "https://your-ias-tenant.accounts.ondemand.com"
```

## Security Considerations

### 1. Credential Management
- Never commit real credentials to version control
- Use environment variables or separate config files
- Rotate credentials regularly

### 2. Network Security
- Use HTTPS for all IAS communication
- Verify IAS tenant URL
- Check certificate validity

### 3. User Management
- Regularly review user access
- Implement proper logout
- Monitor authentication logs

## Next Steps

1. **Test Authentication**: Verify login flow works
2. **Test Authorization**: Check role-based access
3. **Test API Calls**: Verify API endpoints work with IAS tokens
4. **Monitor Logs**: Check for any authentication issues
5. **Deploy to Cloud**: Test in Cloud Foundry environment

## Configuration Files Summary

- `default-env-ias.json`: Real IAS configuration (not in git)
- `.cdsrc.json`: IAS profiles
- `xs-security.json`: XSUAA configuration with IAS trust
- `mta.yaml`: IAS service resource

Remember to add `default-env-ias.json` to your `.gitignore` to avoid committing credentials! 