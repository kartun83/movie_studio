#!/bin/bash

# IAS Local Setup Script
# This script helps you set up real IAS for local testing

echo "🔧 IAS Local Setup Script"
echo "=========================="

# Check if cf CLI is installed
if ! command -v cf &> /dev/null; then
    echo "❌ Cloud Foundry CLI not found. Please install it first."
    exit 1
fi

# Check if user is logged in
if ! cf target &> /dev/null; then
    echo "❌ Not logged into Cloud Foundry. Please run 'cf login' first."
    exit 1
fi

echo "✅ Cloud Foundry CLI is available and logged in"

# Check if services exist
echo "🔍 Checking for required services..."

XSUAA_EXISTS=$(cf services | grep "movie_studio-auth" | wc -l)
IAS_EXISTS=$(cf services | grep "movie_studio-ias" | wc -l)

if [ $XSUAA_EXISTS -eq 0 ]; then
    echo "❌ XSUAA service 'movie_studio-auth' not found"
    echo "   Please create it first: cf create-service xsuaa application movie_studio-auth -c xs-security.json"
    exit 1
fi

if [ $IAS_EXISTS -eq 0 ]; then
    echo "❌ IAS service 'movie_studio-ias' not found"
    echo "   Please create it first: cf create-service identity application movie_studio-ias"
    exit 1
fi

echo "✅ Required services found"

# Get service keys
echo "🔑 Getting service keys..."

# Get XSUAA service key
echo "📋 Getting XSUAA service key..."
XSUAA_KEY_EXISTS=$(cf service-keys movie_studio-auth | grep "movie_studio-auth-key" | wc -l)

if [ $XSUAA_KEY_EXISTS -eq 0 ]; then
    echo "   Creating XSUAA service key..."
    cf create-service-key movie_studio-auth movie_studio-auth-key
else
    echo "   XSUAA service key already exists"
fi

# Get IAS service key
echo "📋 Getting IAS service key..."
IAS_KEY_EXISTS=$(cf service-keys movie_studio-ias | grep "movie_studio-ias-key" | wc -l)

if [ $IAS_KEY_EXISTS -eq 0 ]; then
    echo "   Creating IAS service key..."
    cf create-service-key movie_studio-ias movie_studio-ias-key
else
    echo "   IAS service key already exists"
fi

# Create default-env-ias.json template
echo "📝 Creating default-env-ias.json template..."

cat > default-env-ias.json << 'EOF'
{
  "VCAP_SERVICES": {
    "xsuaa": [
      {
        "name": "movie_studio-auth",
        "tags": ["xsuaa"],
        "credentials": {
          "clientid": "REPLACE_WITH_XSUAA_CLIENT_ID",
          "clientsecret": "REPLACE_WITH_XSUAA_CLIENT_SECRET",
          "url": "REPLACE_WITH_XSUAA_URL",
          "identityzone": "REPLACE_WITH_IDENTITY_ZONE",
          "identityzoneid": "REPLACE_WITH_IDENTITY_ZONE_ID",
          "verificationkey": "REPLACE_WITH_VERIFICATION_KEY",
          "xsappname": "movie_studio"
        }
      }
    ],
    "identity": [
      {
        "name": "movie_studio-ias",
        "tags": ["identity"],
        "credentials": {
          "clientid": "REPLACE_WITH_IAS_CLIENT_ID",
          "clientsecret": "REPLACE_WITH_IAS_CLIENT_SECRET",
          "url": "REPLACE_WITH_IAS_URL",
          "identityzone": "REPLACE_WITH_IAS_ZONE",
          "identityzoneid": "REPLACE_WITH_IAS_ZONE_ID"
        }
      }
    ]
  },
  "VCAP_APPLICATION": {
    "application_name": "movie_studio",
    "application_uris": ["localhost:4004"]
  },
  "destinations": [
    {
      "name": "srv-api",
      "url": "http://localhost:4004"
    }
  ]
}
EOF

echo "✅ Created default-env-ias.json template"

# Display next steps
echo ""
echo "🎯 Next Steps:"
echo "=============="
echo ""
echo "1. 📋 Get your service credentials:"
echo "   cf service-key movie_studio-auth movie_studio-auth-key"
echo "   cf service-key movie_studio-ias movie_studio-ias-key"
echo ""
echo "2. ✏️  Update default-env-ias.json with your actual credentials"
echo ""
echo "3. 🌐 Configure IAS application:"
echo "   - Go to your IAS admin console"
echo "   - Create application 'movie_studio'"
echo "   - Configure OAuth 2.0 with redirect URI: http://localhost:4004/**"
echo "   - Create user groups: AssetManager, Admin, StudioDirector, Consultant, FinancialAnalyst"
echo ""
echo "4. 🚀 Start testing:"
echo "   npm run start:ias-real"
echo ""
echo "📚 For detailed instructions, see REAL_IAS_SETUP.md"
echo ""
echo "✅ Setup script completed!" 