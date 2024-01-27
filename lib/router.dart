import 'package:go_router/go_router.dart';
import 'package:research/features/auth/login_page.dart';
import 'package:research/features/auth/signup_page.dart';

// GoRouter configuration
final router = GoRouter(
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
