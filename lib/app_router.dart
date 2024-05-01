import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:newsx/login/login_screen.dart';
import 'package:newsx/login/verify_screen.dart';
import 'package:newsx/screen/app_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class AppRouter {
  AppRouter._();
  static final instance = AppRouter._();

  final _auth = FirebaseAuth.instance;

  late final router = GoRouter(
    refreshListenable: GoRouterRefreshStream(_auth.authStateChanges()),
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = _auth.currentUser != null;
      final goingToLogin = state.matchedLocation.startsWith('/login');
      // if (state.matchedLocation.startsWith(':uid/seafarer_application')) {
      //   return ':uid/seafarer_application';
      // }
      if (state.matchedLocation.startsWith('/registration')) {
        return '/registration';
      }
      if (!loggedIn && !goingToLogin) {
        return '/login?from=${state.matchedLocation}';
      }
      if (loggedIn && goingToLogin) return '/';

      return null;
    },
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return AppScaffold(
            // selectedIndex: index == -1 ? 0 s: index,
            currentPath: state.uri.path,
            body: child,
            mobileNavs: 3,
            // navList: navList,
          );
        },
        routes: [],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return LoginScreen();
        },
        routes: [
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: ':phone/:verificationId',
            builder: (BuildContext context, GoRouterState state) {
              return VerifyScreen(
                phone: state.pathParameters['phone'],
                verificationId: state.pathParameters['verificationId'],
              );
            },
          ),
        ],
      ),
      // GoRoute(
      //   parentNavigatorKey: _rootNavigatorKey,
      //   path: '/registration',
      //   builder: (BuildContext context, GoRouterState state) {
      //     return RegistrationScreen();
      //   },
      // ),
    ],
  );
}
