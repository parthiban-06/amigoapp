// lib/routes/route_guard.dart
import 'package:flutter/material.dart';

import 'navigator_redirect.dart';

class RouteGuard extends StatelessWidget {
  final Widget child;
  final bool Function() authenticationCheck;
  final String redirectPath;

  const RouteGuard({
    Key? key,
    required this.child,
    required this.authenticationCheck,
    required this.redirectPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return authenticationCheck()
        ? child
        : NavigatorRedirect(path: redirectPath);
  }
}
