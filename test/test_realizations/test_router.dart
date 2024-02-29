import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TestRouter {
  TestRouter(this.initialLocation);

  final Widget initialLocation;

  GoRouter get router => GoRouter(initialLocation: '/', routes: [
        GoRoute(path: '/', builder: (context, state) => initialLocation)
      ]);
}
