# Flutter Intl Utils Integration Guide

A comprehensive guide for integrating and using intl_utils for internationalization (i18n) in
Flutter applications.

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Basic Setup](#basic-setup)
- [Usage](#usage)
- [ARB Files](#arb-files)
- [Generated Files](#generated-files)
- [Examples](#examples)
- [Best Practices](#best-practices)
- [Common Issues](#common-issues)

## Installation

Add intl_utils to your pubspec.yaml file:

```yaml
dependencies:
  intl: ^0.18.0

dev_dependencies:
  intl_utils: ^2.8.5
  build_runner: ^2.4.6
```

Run flutter pub get:

```bash
flutter pub get
```

## Configuration

Add the following configuration to your `pubspec.yaml`:

```yaml
flutter_intl:
  enabled: true
  class_name: S # The class name for the generated localization class
  main_locale: en # Your main locale
  arb_dir: lib/l10n # Directory containing your ARB files
  output_dir: lib/generated # Directory for generated files
#  use_deferred_loading: false # Set to true for deferred loading
```

## Basic Setup

1. Create the localization directory:

```bash
mkdir lib/l10n
```

2. Create ARB files for each locale:

```bash
# lib/l10n/intl_en.arb (English)
{
    "@@locale": "en",
    "appTitle": "My App",
    "@appTitle": {
        "description": "The application title"
    },
    "welcomeMessage": "Welcome {username}",
    "@welcomeMessage": {
        "description": "Welcome message on home screen",
        "placeholders": {
            "username": {
                "type": "String",
                "example": "John"
            }
        }
    }
}

# lib/l10n/intl_es.arb (Spanish)
{
    "@@locale": "es",
    "appTitle": "Mi Aplicación",
    "welcomeMessage": "Bienvenido {username}"
}
```

3. Initialize in your main.dart:

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: MyHomePage(),
    );
  }
}
```

## Usage

### Basic String Usage

```dart
// Access translated strings
Text(S.of(context).appTitle);

// With parameters
Text(S.of(context).welcomeMessage('John'));
```

### Plural Messages

```dart
// In ARB file (intl_en.arb)
{
    "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
    "@itemCount": {
        "description": "Number of items",
        "placeholders": {
            "count": {
                "type": "int",
                "example": "1"
            }
        }
    }
}

// In Dart code
Text(S.of(context).itemCount(5));
```

### Gender Messages

```dart
// In ARB file (intl_en.arb)
{
    "personStatus": "{gender, select, male{He is} female{She is} other{They are}} offline",
    "@personStatus": {
        "description": "Person status with gender",
        "placeholders": {
            "gender": {
                "type": "String",
                "example": "male"
            }
        }
    }
}

// In Dart code
Text(S.of(context).personStatus('male'));
```

### Date and Number Formatting

```dart
// In ARB file (intl_en.arb)
{
    "lastSeen": "Last seen: {date}",
    "@lastSeen": {
        "description": "Last seen date",
        "placeholders": {
            "date": {
                "type": "DateTime",
                "format": "yMd"
            }
        }
    },
    "price": "Price: {amount}",
    "@price": {
        "description": "Product price",
        "placeholders": {
            "amount": {
                "type": "double",
                "format": "currency",
                "optionalParameters": {
                    "symbol": "$",
                    "decimalDigits": 2
                }
            }
        }
    }
}

// In Dart code
Text(S.of(context).lastSeen(DateTime.now()));
Text(S.of(context).price(19.99));
```

## ARB Files Structure

### Basic Structure

```arb
{
    "@@locale": "en",
    "key": "value",
    "@key": {
        "description": "Description of the string",
        "placeholders": {
            "name": {
                "type": "String",
                "example": "example value"
            }
        }
    }
}
```

### Supported Placeholder Types

- String
- int
- double
- num
- DateTime
- Object

## Generated Files

After running the generator, the following files will be created:

```
lib/generated/
├── intl/
│   ├── messages_all.dart
│   ├── messages_en.dart
│   └── messages_es.dart
└── l10n.dart
```


## Examples

### Complete Widget Example

```dart
class LocalizedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
      ),
      body: Column(
        children: [
          // Simple text
          Text(S.of(context).welcomeMessage('John')),
          
          // Plural message
          Text(S.of(context).itemCount(5)),
          
          // Gender specific message
          Text(S.of(context).personStatus('female')),
          
          // Date formatting
          Text(S.of(context).lastSeen(DateTime.now())),
          
          // Number formatting
          Text(S.of(context).price(19.99)),
          
          // Locale switcher
          DropdownButton<Locale>(
            value: Localizations.localeOf(context),
            items: S.delegate.supportedLocales.map((Locale locale) {
              return DropdownMenuItem<Locale>(
                value: locale,
                child: Text(locale.languageCode),
              );
            }).toList(),
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                // Update locale using provider or state management
              }
            },
          ),
        ],
      ),
    );
  }
}
```

## Best Practices

1. **Organized ARB Files:**

```arb
{
    "@@locale": "en",
    
    "// General": {},
    "appTitle": "My App",
    "appDescription": "Welcome to my app",
    
    "// Auth Screens": {},
    "loginTitle": "Login",
    "loginButton": "Sign In",
    
    "// Home Screens": {},
    "homeTitle": "Home",
    "welcomeMessage": "Welcome back"
}
```

2. **Use Description and Placeholders:**

```arb
{
    "meetingTime": "Meeting at {time} on {date}",
    "@meetingTime": {
        "description": "Shows the meeting schedule",
        "placeholders": {
            "time": {
                "type": "String",
                "example": "10:00 AM"
            },
            "date": {
                "type": "DateTime",
                "format": "yMd"
            }
        }
    }
}
```

3. **Consistent Naming Convention:**

```arb
{
    // Screen specific
    "loginScreen_title": "Login",
    "loginScreen_button": "Sign In",
    
    // Feature specific
    "auth_errorMessage": "Invalid credentials",
    "auth_successMessage": "Login successful"
}
```

## Common Issues

1. **Missing Translations**

```dart
// Add fallback logic
Text(S.of(context).someKey ?? 'Fallback Text');

// Or use try-catch
try {
  Text(S.of(context).someKey);
} catch (e) {
  Text('Fallback Text');
}
```

2. **Locale Not Updating**

```dart
// Wrap your app with a locale provider
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _currentLocale, // Controlled by state management
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: MyHomePage(),
    );
  }
}
```

3. **Generation Issues**

```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter pub run intl_utils:generate
```
# If issues persist, delete generated folder and regenerate

```bash
flutter pub run intl_utils:generate
```

## Script for Managing Translations

Create a script to help manage translations:

```dart
// tools/translation_helper.dart
import 'dart:convert';
import 'dart:io';

void main() async {
  final baseFile = File('lib/l10n/intl_en.arb');
  final base = json.decode(await baseFile.readAsString());

  final directories = Directory('lib/l10n').listSync();
  for (var file in directories) {
    if (file.path.endsWith('.arb') && !file.path.contains('_en.arb')) {
      final current = json.decode(await File(file.path).readAsString());
      final missing = <String>[];

      base.forEach((key, value) {
        if (key.startsWith('@')) return;
        if (!current.containsKey(key)) {
          missing.add(key);
        }
      });

      if (missing.isNotEmpty) {
        print('Missing translations in ${file.path}:');
        missing.forEach(print);
      }
    }
  }
}
```

Run the script to find missing translations:

```bash
dart tools/translation_helper.dart
```

To generate files, run:

```bash
flutter pub run intl_utils:generate
```