import 'package:dinereserve/core/router/app_router_const.dart';
import 'package:dinereserve/core/router/page_transitions.dart';
import 'package:dinereserve/feature/splash/presentation/view/splash_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRouterConst.splashViewRouteName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashView(),
          transitionsBuilder: PageTransitions.noTransition,
        ),
      ),
    ],
  );
}
