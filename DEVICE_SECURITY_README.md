# Device Security Implementation

This document describes the implementation of device security checks for the Visa Amigo app, which
detects rooted/jailbroken devices and developer mode on Android and iOS platforms.

## Overview

The device security implementation uses Flutter method channels to communicate with native Android
and iOS code for comprehensive security checks. The system is designed to:

- Detect rooted devices on Android
- Detect jailbroken devices on iOS
- Detect developer mode on both platforms
- Skip checks on web platform
- Handle errors gracefully to avoid blocking legitimate users

## Architecture

### Flutter Layer

- **DeviceSecurityService** (`lib/utils/device_security_service.dart`): Main service that handles
  method channel communication
- **SplashScreenViewModel** (`lib/features/splash_screen/model/splash_screen_model.dart`):
  Integrates security checks into app initialization

### Android Layer

- **MainActivity** (`android/app/src/main/kotlin/com/visa/eva/MainActivity.kt`): Implements native
  Android security checks
- Method channel: `device_security_channel`

### iOS Layer

- **AppDelegate** (`ios/Runner/AppDelegate.swift`): Implements native iOS security checks
- Method channel: `device_security_channel`

## Security Checks

### Android Root Detection

The Android implementation checks for:

1. **Common root indicators**:
    - `/system/app/Superuser.apk`
    - `/sbin/su`, `/system/bin/su`, `/system/xbin/su`
    - `/data/local/xbin/su`, `/data/local/bin/su`
    - `/system/sd/xbin/su`, `/system/bin/failsafe/su`
    - `/data/local/su`, `/su/bin/su`

2. **Build tags**: Checks if `Build.TAGS` contains "test-keys"

3. **SU command availability**: Tests if `su` command is available in the system (most reliable
   method)

**Note**: The implementation does not check for specific root apps to comply with Play Store
policies and privacy requirements.

### iOS Jailbreak Detection

The iOS implementation checks for:

1. **Common jailbreak indicators**:
    - `/Applications/Cydia.app`
    - `/Library/MobileSubstrate/MobileSubstrate.dylib`
    - `/bin/bash`, `/usr/sbin/sshd`
    - `/etc/apt`, `/private/var/lib/apt/`
    - `/private/var/lib/cydia`
    - Various MobileSubstrate and launch daemon files

2. **System directory write permissions**: Checks if app can write to system directories

3. **Suspicious environment variables**: Checks for `DYLD_INSERT_LIBRARIES` and `DYLD_LIBRARY_PATH`

4. **Process forking capability**: Tests if the app can fork processes (indicates jailbreak)

### Developer Mode Detection

#### Android

- Checks `Settings.Global.ADB_ENABLED` setting

#### iOS

- Checks if app is running in DEBUG mode using `#if DEBUG` compiler directive

## Usage

### Basic Usage

```dart
import 'package:visaamigo/utils/device_security_service.dart';

// Check if device is compromised
bool isCompromised = await DeviceSecurityService.isDeviceCompromised();

// Check if developer mode is enabled
bool isDeveloperMode = await DeviceSecurityService.isDeveloperModeEnabled();

// Perform comprehensive security check
Map<String, dynamic> securityResult = await DeviceSecurityService.performSecurityCheck();
```

### Integration in Splash Screen

The security checks are automatically performed during app initialization in the splash screen:

```dart
// In SplashScreenViewModel.init()
if (!kDebugMode && isForAnalyticsBuild) {
  await _performDeviceSecurityCheck(deepLinkEmail);
} else {
  runAppFunctionliaty(deepLinkEmail);
}
```

## Method Channel API

### Methods

- `isDeviceCompromised`: Returns `bool` indicating if device is rooted/jailbroken
- `isDeveloperModeEnabled`: Returns `bool` indicating if developer mode is enabled
- `performSecurityCheck`: Returns `Map<String, dynamic>` with comprehensive security status

### Response Format for `performSecurityCheck`

```json
{
  "isCompromised": false,
  "isDeveloperMode": false, 
  "isSecure": true,
  "platform": "android|ios|web"
}
```

## Error Handling

The implementation includes comprehensive error handling:

- **Platform exceptions**: Returns safe defaults (assumes device is secure)
- **Unexpected exceptions**: Logs error and continues with app functionality
- **Web platform**: Automatically skips checks and returns secure status
- **Debug mode**: Skips security checks when `kDebugMode` is true

## Testing

### Unit Tests

Run the device security service tests:

```bash
flutter test test/utils/device_security_service_test.dart
```

### Manual Testing

1. **Android**: Test on rooted and non-rooted devices
2. **iOS**: Test on jailbroken and non-jailbroken devices
3. **Developer Mode**: Test with ADB enabled/disabled on Android, debug/release builds on iOS

## Security Considerations

### False Positives

The implementation is designed to minimize false positives:

- Returns safe defaults on errors
- Skips checks in debug mode
- Uses multiple detection methods to reduce false positives

### Evasion Techniques

Note that sophisticated root/jailbreak detection evasion techniques may bypass these checks:

- Advanced root hiding tools
- Custom ROMs with modified system files
- Runtime manipulation of security checks

### Recommendations

1. **Regular updates**: Keep detection methods updated as new root/jailbreak techniques emerge
2. **Server-side validation**: Consider additional server-side security measures
3. **Behavioral analysis**: Implement additional runtime security checks
4. **Code obfuscation**: Protect the security check code from reverse engineering
5. **Privacy compliance**: Avoid checking for specific app packages to comply with store policies
6. **Transparent detection**: Use file system and command availability checks instead of app
   detection

## Platform-Specific Notes

### Android

- Requires `READ_EXTERNAL_STORAGE` permission for some checks
- May trigger security warnings in some antivirus software
- Works on Android 4.0+ (API level 14+)

### iOS

- Jailbreak detection is more reliable due to iOS security model
- Some checks may be blocked by iOS security policies
- Works on iOS 9.0+

### Web

- All checks return false/secure status
- No native security checks performed
- Suitable for web deployment

## Troubleshooting

### Common Issues

1. **Method channel not found**: Ensure native code is properly integrated
2. **Permission denied**: Check Android permissions for file system access
3. **Build errors**: Verify native code compilation on both platforms

### Debugging

Enable verbose logging by checking the console output for security check results:

```
Security check result - Compromised: false, Developer Mode: false, Secure: true, Platform: android
```

## Future Enhancements

Potential improvements for future versions:

1. **Runtime integrity checks**: Verify app code hasn't been modified
2. **Network-based validation**: Server-side security verification
3. **Advanced detection methods**: Machine learning-based anomaly detection
4. **Real-time monitoring**: Continuous security status monitoring 