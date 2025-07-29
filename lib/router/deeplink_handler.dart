import 'package:visaamigo/utils/app_extensions.dart';

import '../utils/utils.dart';
import 'app_router.dart';
import 'app_routes_const.dart';

class DeepLinkHandler {
  final Uri uri;

  DeepLinkHandler(this.uri) {
    _handleDeepLink(uri);
  }

  void _handleDeepLink(Uri uri) {
    try {
      final path = uri.path;
      final queryParams = uri.queryParameters;

      // Remove any prefix from the path if needed
      final cleanPath = path.startsWith('/') ? path : '/$path';

      Utils.logPrint('uri: $uri');
      Utils.logPrint('cleanPath: $cleanPath');
      Utils.logPrint('path: $path');
      Utils.logPrint('queryParams: $queryParams');

      // Extract the first segment of the path
      final segments = cleanPath.split('/')
        ..removeWhere((segment) => segment.isEmpty);

      if (segments.isEmpty) {
        Utils.logPrint('segments empty: $queryParams');
        AppRouter.router.goRoute(AppRoutes.splashScreen, extra: queryParams);
        return;
      }

      Utils.logPrint('segments: $segments');

      switch (segments[0]) {
        case 'product' when segments.length > 1:
          final productId = segments[1];
          AppRouter.router.pushNamed(
            AppRoutes.homeNav,
            pathParameters: {'productId': productId},
            queryParameters: queryParams,
          );

        case 'signupemail':
          AppRouter.router.goRoute(
            AppRoutes.splashScreen,
            extra: queryParams,
          );

          break;
        case 'category' when segments.length > 1:
          final categoryId = segments[1];
          AppRouter.router.goNamedRoute(
            AppRoutes.homeNav,
            pathParameters: {'categoryId': categoryId},
          );
          break;

        case 'drawer' when segments.length > 1:
          final userId = segments[1];
          AppRouter.router.goNamedRoute(
            AppRoutes.homeNav,
            pathParameters: {'userId': userId},
          );
          break;

        default:
          // No valid route found, will fall through to home redirect
          Utils.logPrint('segments default: $queryParams');

          AppRouter.router.goRoute(AppRoutes.splashScreen, extra: queryParams);
      }
    } catch (e) {
      Utils.logPrint('Error handling deep link: $e');
    }
  }
}
