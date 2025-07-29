import 'package:flutter/material.dart';

class NavigatorRedirect extends StatefulWidget {
  final String path;

  const NavigatorRedirect({Key? key, required this.path}) : super(key: key);

  @override
  State<NavigatorRedirect> createState() => _NavigatorRedirectState();
}

class _NavigatorRedirectState extends State<NavigatorRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(widget.path);
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
