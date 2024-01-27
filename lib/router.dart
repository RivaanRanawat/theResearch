import 'package:go_router/go_router.dart';
import 'package:research/features/auth/pages/login_page.dart';
import 'package:research/features/auth/pages/signup_page.dart';
import 'package:research/features/home/pages/home_page.dart';

final loggedOutRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpPage(),
    ),
  ],
);

final loggedInRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpPage(),
    ),
  ],
);
