import 'package:eum.dev/pages/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:eum.dev/pages/404.dart';
import 'package:eum.dev/pages/home.dart';

final router = GoRouter(
    errorBuilder: (context, state) {
      return const NotFoundPage();
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      /*GoRoute(
        path: '/note/:noteId',
        builder: (context, state) {
          return NotePage(noteId: state.pathParameters['noteId'] ?? "");
        },
      ),*/
       GoRoute(path: '/login', builder: (context, state) => const RegisterPage()),
    ]);
/*
final getPages = [
  GetPage(
    name: '/',
    page: () => const HomePage(),
  ),
  /* GetPage(
    name: '/note/:noteId',
    page: () {
      final noteId = Get.parameters['noteId'] ?? "";
      return NotePage(noteId: noteId);
    },
  ),*/
  /* GetPage(
    name: '/auth',
    page: () => const RegisterPage(),
  ),*/
];
*/