# UI5 i18n Configuration Guide

## Overview
This guide explains how to properly configure internationalization (i18n) in UI5 projects to resolve the warning about fallback locales.

## Current Setup
The project now has the following i18n configuration:

### File Structure
```
webapp/i18n/
├── i18n.properties          # Default fallback locale
├── i18n_en.properties      # English locale
├── i18n_es.properties      # Spanish locale
└── i18n_ru.properties      # Russian locale
```

### Manifest Configuration
The `manifest.json` has been updated with proper i18n settings:

```json
"sap.app": {
  "i18n": {
    "bundleUrl": "i18n/i18n.properties",
    "supportedLocales": ["en", "es", "ru"],
    "fallbackLocale": "en"
  }
}
```

### Model Configuration
The i18n models are configured with proper locale settings:

```json
"models": {
  "i18n": {
    "type": "sap.ui.model.resource.ResourceModel",
    "settings": {
      "bundleName": "com.kartun.movie_studio.i18n.i18n",
      "supportedLocales": ["en", "es", "ru"],
      "fallbackLocale": "en"
    }
  },
  "@i18n": {
    "type": "sap.ui.model.resource.ResourceModel",
    "uri": "i18n/i18n.properties",
    "settings": {
      "supportedLocales": ["en"],
      "fallbackLocale": "en"
    }
  }
}
```

## Key Configuration Points

### 1. File Naming Convention
- `i18n.properties` - Default fallback file (no locale suffix)
- `i18n_en.properties` - English locale file
- `i18n_es.properties` - Spanish locale file
- `i18n_ru.properties` - Russian locale file
- `i18n_de.properties` - German locale file (if needed)
- `i18n_fr.properties` - French locale file (if needed)

### 2. Manifest.json Configuration
The `sap.app.i18n` section should specify:
- `bundleUrl`: Path to the default properties file
- `supportedLocales`: Array of supported locale codes
- `fallbackLocale`: The fallback locale when a specific locale is not found

### 3. Model Configuration
Each i18n model should include:
- `supportedLocales`: Array of supported locales
- `fallbackLocale`: Fallback locale setting

## Adding New Locales

To add support for additional locales (e.g., German):

1. Create the locale file:
   ```
   webapp/i18n/i18n_de.properties
   ```

2. Update the manifest.json:
   ```json
   "sap.app": {
     "i18n": {
       "bundleUrl": "i18n/i18n.properties",
       "supportedLocales": ["en", "es", "ru", "de"],
       "fallbackLocale": "en"
     }
   }
   ```

3. Update model configurations:
   ```json
   "settings": {
     "supportedLocales": ["en", "es", "ru", "de"],
     "fallbackLocale": "en"
   }
   ```

## Usage in Views

### XML Views
```xml
<Text text="{i18n>appTitle}" />
<Button text="{i18n>saveButton}" />
```

### JavaScript/TypeScript
```javascript
// Get i18n model
const i18nModel = this.getView().getModel("i18n");

// Get text
const title = i18nModel.getResourceBundle().getText("appTitle");

// Or use the model directly
const title = this.getView().getModel("i18n").getProperty("/appTitle");
```

## Best Practices

1. **Always provide a fallback locale** - This prevents the warning you were seeing
2. **Use descriptive keys** - Make keys self-documenting
3. **Group related texts** - Use prefixes like `button.`, `label.`, `message.`
4. **Keep files in sync** - When adding new keys, add them to all locale files
5. **Use comments** - Add comments to explain context for translators

## Example Properties File Structure
```properties
# Application texts
appTitle=Movie Studio Management
appDescription=An SAP Fiori application for movie studio management

# Button texts
button.save=Save
button.cancel=Cancel
button.delete=Delete

# Message texts
message.saveSuccess=Data saved successfully
message.deleteConfirm=Are you sure you want to delete this item?

# Label texts
label.title=Title
label.description=Description
label.status=Status
```

## Troubleshooting

### Common Issues

1. **Warning about fallback locale**: Ensure `fallbackLocale` is set and matches a supported locale
2. **Missing texts**: Check that the key exists in the properties file
3. **Wrong bundle name**: Verify the bundle name in model configuration matches your namespace

### Debug Tips

1. Check browser console for i18n-related errors
2. Verify file paths in manifest.json
3. Ensure all locale files have the same keys
4. Test with different browser language settings

## Additional Resources

- [UI5 i18n Documentation](https://sapui5.hana.ondemand.com/#/topic/91f21f176f4d1014b6dd926db0e91070)
- [Resource Model API](https://sapui5.hana.ondemand.com/#/api/sap.ui.model.resource.ResourceModel)
- [SAP Fiori Design Guidelines - Internationalization](https://experience.sap.com/fiori-design-web/internationalization/) 