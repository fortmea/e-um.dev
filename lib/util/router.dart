import 'package:go_router/go_router.dart';
import 'package:mercury/pages/404.dart';
import 'package:mercury/pages/home.dart';
import 'package:mercury/pages/note.dart';
import 'package:mercury/pages/auth.dart';

final router = GoRouter(
    errorBuilder: (context, state) {
      return const NotFoundPage();
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/note/:noteId',
        builder: (context, state) {
          return NotePage(postId: state.pathParameters['noteId'] ?? "");
        },
      ),
      GoRoute(path: '/auth', builder: (context, state) => const RegisterPage()),
    ]);
