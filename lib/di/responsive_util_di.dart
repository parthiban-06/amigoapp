import 'package:flutter/material.dart' show BuildContext;
import 'package:get_it/get_it.dart';
import 'package:visaamigo/utils/responsive_util.dart';

void setupResponsiveUtilDI(GetIt getIt) {
  // Register ResponsiveUtil as a factory
  getIt.registerFactoryParam<ResponsiveUtil, BuildContext, void>(
    (ctx, _) => ResponsiveUtil(ctx),
  );
}
