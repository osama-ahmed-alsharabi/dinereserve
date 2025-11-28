import 'package:dinereserve/core/services/user_local_service.dart';
import 'package:dinereserve/core/utils/app_asset.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/feature/notification/data/notification_repo.dart';
import 'package:dinereserve/feature/notification/presentation/view/notifications_view.dart';
import 'package:dinereserve/feature/notification/presentation/view/widgets/notification_badge.dart';
import 'package:dinereserve/feature/notification/presentation/view_model/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({super.key});

  String _getGreeting() {
    final hour = TimeOfDay.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = getIt<UserLocalService>().getUser();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryColor, width: 2),
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey[200],
                backgroundImage: user?.image != null
                    ? NetworkImage(user!.image!)
                    : const NetworkImage('https://i.pravatar.cc/150?img=12')
                          as ImageProvider,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  user?.fullName ?? "Guest",
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) =>
                      NotificationCubit(getIt<NotificationRepo>()),
                  child: const NotificationsView(),
                ),
              ),
            );
          },
          child: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              final unreadCount = state is NotificationLoaded
                  ? state.unreadCount
                  : 0;

              return NotificationBadge(
                count: unreadCount,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.thirdColor,
                    border: Border.all(color: Colors.white),
                  ),
                  child: SvgPicture.asset(
                    AppAsset.imagesNotifications,
                    height: 25,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
