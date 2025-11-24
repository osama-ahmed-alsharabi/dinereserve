import 'package:dinereserve/core/router/app_router_const.dart';
import 'package:dinereserve/core/router/page_transitions.dart';
import 'package:dinereserve/core/widgets/main_view.dart';
import 'package:dinereserve/feature/auth/login/presentation/view/login_view.dart';
import 'package:dinereserve/feature/auth/register/presentation/view/register_view.dart';
import 'package:dinereserve/feature/on_boarding/presentation/view/onboarding_view.dart';
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
      GoRoute(
        path: '/${AppRouterConst.dineReserveView}',
        name: AppRouterConst.dineReserveView,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const DineReserveView(),
          transitionsBuilder: PageTransitions.noTransition,
        ),
      ),
      GoRoute(
        path: '/${AppRouterConst.registerViewRouteName}',
        name: AppRouterConst.registerViewRouteName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterView(),
          transitionsBuilder: PageTransitions.noTransition,
        ),
      ),
      GoRoute(
        path: '/${AppRouterConst.onBoardingViewRouteName}',
        name: AppRouterConst.onBoardingViewRouteName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingView(),
          transitionsBuilder: PageTransitions.noTransition,
        ),
      ),
      GoRoute(
        path: '/${AppRouterConst.loginViewRouteName}',
        name: AppRouterConst.loginViewRouteName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginView(),
          transitionsBuilder: PageTransitions.noTransition,
        ),
      ),
      GoRoute(
        path: '/${AppRouterConst.mainViewRouteName}',
        name: AppRouterConst.mainViewRouteName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainView(),
          transitionsBuilder: PageTransitions.noTransition,
        ),
      ),
    ],
  );
}
