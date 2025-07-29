import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// A generic service to handle permissions in a Flutter application.
/// Uses permission_handler package to request and check permissions.
class PermissionService {
  /// Singleton instance
  static final PermissionService _instance = PermissionService._internal();

  /// Factory constructor to return the same instance every time
  factory PermissionService() => _instance;

  /// Private constructor
  PermissionService._internal();

  /// Request a specific permission
  ///
  /// Returns [true] if permission is granted, [false] otherwise
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  /// Check if a permission is granted
  ///
  /// Returns [true] if permission is granted, [false] otherwise
  Future<bool> hasPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// Request multiple permissions at once
  ///
  /// Returns a [Map] with permission as key and grant status as value
  Future<Map<Permission, bool>> requestPermissions(
      List<Permission> permissions) async {
    Map<Permission, bool> results = {};

    for (var permission in permissions) {
      final status = await permission.request();
      results[permission] = status.isGranted;
    }

    return results;
  }

  /// Check if all required permissions are granted
  ///
  /// Returns [true] if all permissions are granted, [false] otherwise
  Future<bool> hasRequiredPermissions(List<Permission> permissions) async {
    for (var permission in permissions) {
      final status = await permission.status;
      if (!status.isGranted) return false;
    }
    return true;
  }

  /// Show permission dialog with custom messages and handle user choice
  ///
  /// Returns [true] if user grants permission or goes to settings, [false] otherwise
  Future<bool> showPermissionDialog({
    required BuildContext context,
    required String title,
    required String message,
    required Permission permission,
    String? grantButtonText,
    String? openSettingsButtonText,
    String? cancelButtonText,
  }) async {
    // Capture context-dependent data before async operations
    final navigator = Navigator.of(context);
    final openSettingsBtnText = openSettingsButtonText ?? 'Open Settings';
    final cancelBtnText = cancelButtonText ?? 'Cancel';
    final grantBtnText = grantButtonText ?? 'Grant';

    final PermissionStatus status = await permission.status;

    // If already granted, return true
    if (status.isGranted) return true;

    // If permanently denied, show dialog to open settings
    if (status.isPermanentlyDenied) {
      return await _showSettingsDialog(
        navigator: navigator,
        title: title,
        message: message,
        openSettingsButtonText: openSettingsBtnText,
        cancelButtonText: cancelBtnText,
      );
    }

    // Otherwise, request permission
    final result = await permission.request();

    // If permission granted, return true
    if (result.isGranted) return true;

    // If permission denied but can request again, show dialog to explain
    if (result.isDenied) {
      final shouldRequestAgain = await _showRequestDialog(
        navigator: navigator,
        title: title,
        message: message,
        grantButtonText: grantBtnText,
        cancelButtonText: cancelBtnText,
      );

      if (shouldRequestAgain) {
        // Request permission again
        final newResult = await permission.request();
        return newResult.isGranted;
      }
    }

    // If permanently denied after request, show dialog to open settings
    if (result.isPermanentlyDenied) {
      return await _showSettingsDialog(
        navigator: navigator,
        title: title,
        message: message,
        openSettingsButtonText: openSettingsBtnText,
        cancelButtonText: cancelBtnText,
      );
    }

    return false;
  }

  /// Show dialog to explain why the permission is needed
  Future<bool> _showRequestDialog({
    required NavigatorState navigator,
    required String title,
    required String message,
    required String grantButtonText,
    required String cancelButtonText,
  }) async {
    final result = await showDialog<bool>(
      context: navigator.context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelButtonText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(grantButtonText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Show dialog to open settings
  Future<bool> _showSettingsDialog({
    required NavigatorState navigator,
    required String title,
    required String message,
    required String openSettingsButtonText,
    required String cancelButtonText,
  }) async {
    final result = await showDialog<bool>(
      context: navigator.context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelButtonText),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context, true);
            },
            child: Text(openSettingsButtonText),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
