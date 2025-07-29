import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_service.dart';

/// A provider class to manage permissions state across the application.
class PermissionProvider extends ChangeNotifier {
  final PermissionService _permissionService = PermissionService();

  // Store permission status for quick access
  final Map<Permission, bool> _permissionStatus = {};

  /// Get permission status map
  Map<Permission, bool> get permissionStatus => _permissionStatus;

  /// Check if a specific permission is granted
  bool isPermissionGranted(Permission permission) {
    return _permissionStatus[permission] ?? false;
  }

  /// Initialize permission status for a list of permissions
  Future<void> initPermissions(List<Permission> permissions) async {
    for (var permission in permissions) {
      final status = await _permissionService.hasPermission(permission);
      _permissionStatus[permission] = status;
    }
    notifyListeners();
  }

  /// Request a single permission
  ///
  /// Returns [true] if granted, [false] otherwise
  Future<bool> requestPermission(Permission permission) async {
    final result = await _permissionService.requestPermission(permission);
    _permissionStatus[permission] = result;
    notifyListeners();
    return result;
  }

  /// Request multiple permissions at once
  ///
  /// Returns a [Map] with permission as key and grant status as value
  Future<Map<Permission, bool>> requestPermissions(
      List<Permission> permissions) async {
    final results = await _permissionService.requestPermissions(permissions);

    // Update internal status map
    _permissionStatus.addAll(results);
    notifyListeners();

    return results;
  }

  /// Request permission with UI dialog if needed
  ///
  /// Shows explanation dialog and handles permission flow
  Future<bool> requestPermissionWithDialog({
    required BuildContext context,
    required Permission permission,
    required String title,
    required String message,
    String? grantButtonText,
    String? openSettingsButtonText,
    String? cancelButtonText,
  }) async {
    final result = await _permissionService.showPermissionDialog(
      context: context,
      title: title,
      message: message,
      permission: permission,
      grantButtonText: grantButtonText,
      openSettingsButtonText: openSettingsButtonText,
      cancelButtonText: cancelButtonText,
    );

    // Update internal status
    _permissionStatus[permission] =
        await _permissionService.hasPermission(permission);
    notifyListeners();

    return result;
  }

  /// Check if all required permissions are granted
  Future<bool> hasRequiredPermissions(List<Permission> permissions) async {
    // First check the cache
    bool allGrantedInCache = true;
    for (var permission in permissions) {
      if (_permissionStatus[permission] != true) {
        allGrantedInCache = false;
        break;
      }
    }

    // If all permissions are already known to be granted, return true
    if (allGrantedInCache && _permissionStatus.isNotEmpty) {
      return true;
    }

    // Otherwise, check with the system and update cache
    final result = await _permissionService.hasRequiredPermissions(permissions);

    // If result is true, update all permissions in the list to be granted
    if (result) {
      for (var permission in permissions) {
        _permissionStatus[permission] = true;
      }
      notifyListeners();
    }

    return result;
  }

  /// Open app settings
  void openSettings() {
    openAppSettings();
  }
}
