# IAS (Identity Authentication Service) Integration

This document explains how to set up and use IAS with your CAP application.

## Prerequisites

1. IAS instance created in Cloud Foundry
2. XSUAA service instance configured
3. Proper entitlements for both services

## Setup Steps

### 1. Create IAS Instance

```bash
# Create IAS instance
cf create-service identity application movie_studio-ias

# Create XSUAA instance with IAS integration
cf create-service xsuaa application movie_studio-auth -c xs-security.json
```

### 2. Configure IAS in Cloud Foundry

1. Go to your IAS tenant
2. Create a new application
3. Configure OAuth 2.0 settings
4. Set redirect URIs to your application URL
5. Note down the Client ID and Client Secret

### 3. Configure XSUAA with IAS

Update your XSUAA service instance to trust IAS:

```bash
cf update-service movie_studio-auth -c xs-security.json
```

### 4. Deploy Your Application

```bash
# Build and deploy
npm run build:deploy

# Or deploy manually
mbt build
cf deploy movie_studio_1.0.0.mtar
```

## Configuration Files

### MTA Configuration (mta.yaml)
- Added IAS service resource
- Configured XSUAA to trust IAS
- Set up proper OAuth2 configuration

### XS Security (xs-security.json)
- Added IAS origin attribute
- Maintained existing scopes and roles
- Configured for IAS integration

### Package.json
- Added IAS profile configuration
- Set identity-provider to "ias" for production

## Usage

### Local Development with IAS
```bash
# Use IAS profile for local development
npm run start:ias
```

### Production Deployment
The application will automatically use IAS in production when deployed to Cloud Foundry.

## User Management

### IAS User Configuration
1. Create users in IAS tenant
2. Assign groups/roles in IAS
3. Map IAS groups to XSUAA scopes

### Role Mapping
- IAS groups should map to XSUAA scopes
- Example: IAS group "AssetManager" → XSUAA scope "$XSAPPNAME.AssetManager"

## Troubleshooting

### Common Issues

1. **Authentication Failures**
   - Check IAS application configuration
   - Verify redirect URIs
   - Ensure XSUAA trusts IAS

2. **Role Mapping Issues**
   - Verify IAS groups are properly configured
   - Check XSUAA scope assignments
   - Review user group memberships

3. **Token Issues**
   - Check token validity settings
   - Verify OAuth2 configuration
   - Review service bindings

### Debug Commands

```bash
# Check service instances
cf services

# View service keys
cf service-key movie_studio-auth movie_studio-auth-key

# Check application logs
cf logs movie_studio --recent
```

## Security Considerations

1. **Token Security**
   - Use HTTPS in production
   - Configure proper token validity
   - Implement proper logout

2. **User Management**
   - Regular user access reviews
   - Proper role assignments
   - Audit logging

3. **Network Security**
   - Secure communication between services
   - Proper firewall rules
   - Network isolation where possible

## Additional Resources

- [SAP IAS Documentation](https://help.sap.com/docs/IDENTITY_AUTHENTICATION)
- [CAP Authentication Guide](https://cap.cloud.sap/docs/guides/authentication)
- [XSUAA IAS Integration](https://help.sap.com/docs/XSUAA/identity-authentication-service-ias) 