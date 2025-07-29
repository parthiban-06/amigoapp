// platform_view_registry_stub.dart
// Used for mobile platforms where `platformViewRegistry` doesn't exist

class PlatformViewRegistryStub {
  void registerViewFactory(String viewType, dynamic Function(int) cb) {
    // Do nothing on mobile
  }
}

final platformViewRegistry = PlatformViewRegistryStub();
