import 'package:dinereserve/core/model/booking_model.dart';
import 'package:dinereserve/core/router/app_router_const.dart';
import 'package:dinereserve/core/router/page_transitions.dart';
import 'package:dinereserve/core/widgets/main_rest_view.dart';
import 'package:dinereserve/core/widgets/main_view.dart';
import 'package:dinereserve/feature/auth/login/presentation/view/login_view.dart';
import 'package:dinereserve/feature/auth/login_rest/presentation/view/login_rest.dart';
import 'package:dinereserve/feature/auth/register/presentation/view/register_view.dart';
import 'package:dinereserve/feature/auth/register_rest/presentation/view/register_rest_view.dart';
import 'package:dinereserve/feature/booking/presentation/view/booking_detail_view.dart';
import 'package:dinereserve/feature/on_boarding/presentation/view/onboarding_view.dart';
import 'package:dinereserve/feature/splash/presentation/view/splash_view.dart';
import 'package:dinereserve/feature/advertisement/presentation/view/add_advertisement_view.dart';
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
      GoRoute(
        path: '/${AppRouterConst.registerRestViewRouteName}',
        name: AppRouterConst.registerRestViewRouteName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterRestView(),
          transitionsBuilder: PageTransitions.noTransition,
        ),
      ),
      GoRoute(
        path: '/${AppRouterConst.loginRestViewRouteName}',
        name: AppRouterConst.loginRestViewRouteName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginRestView(),
          transitionsBuilder: PageTransitions.noTransition,
        ),
      ),
      GoRoute(
        path: '/${AppRouterConst.mainRestViewRouteName}',
        name: AppRouterConst.mainRestViewRouteName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MainRestView(),
          transitionsBuilder: PageTransitions.noTransition,
        ),
      ),
      GoRoute(
        path: '/${AppRouterConst.addAdvertisementViewRouteName}',
        name: AppRouterConst.addAdvertisementViewRouteName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AddAdvertisementView(),
          transitionsBuilder: PageTransitions.noTransition,
        ),
      ),
      GoRoute(
        path: '/${AppRouterConst.bookingDetailViewRouteName}',
        name: AppRouterConst.bookingDetailViewRouteName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          arguments: state.extra,
          child: BookingDetailView(booking: state.extra as BookingModel),
          transitionsBuilder: PageTransitions.noTransition,
        ),
      ),
    ],
  );
}
