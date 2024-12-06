import 'package:go_router/go_router.dart';
import 'package:mercury/pages/home.dart';
import 'package:mercury/pages/login.dart';
import 'package:mercury/pages/note.dart';
import 'package:mercury/pages/register.dart';

final router = GoRouter(routes: <RouteBase>[
  GoRoute(
    path: '/',
    builder: (context, state) => HomePage(),
  ),
  GoRoute(
    path: '/note/:noteId',
    builder: (context, state) {
      return NotePage(postId: state.pathParameters['noteId'] ?? "");
    },
  ),
  GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
  GoRoute(path: '/login', builder: (context, state) => LoginPage()),
]);
