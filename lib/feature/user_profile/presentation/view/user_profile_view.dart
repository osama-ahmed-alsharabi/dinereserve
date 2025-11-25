import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/user_profile/presentation/view/widgets/user_profile_header.dart';
import 'package:dinereserve/feature/user_profile/presentation/view/widgets/user_profile_logout_button.dart';
import 'package:dinereserve/feature/user_profile/presentation/view/widgets/user_profile_settings_section.dart';
import 'package:dinereserve/feature/user_profile/presentation/view_model/user_profile_cubit.dart';
import 'package:dinereserve/feature/user_profile/presentation/view_model/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  void initState() {
    super.initState();
    // Fetch profile when view initializes
    context.read<UserProfileCubit>().fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: BlocConsumer<UserProfileCubit, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileLogoutSuccess) {
            context.go('/login'); // Adjust route as needed
          } else if (state is UserProfileLogoutError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errMessage)));
          }
        },
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          } else if (state is UserProfileError) {
            return Center(child: Text(state.errMessage));
          } else if (state is UserProfileLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  UserProfileHeader(user: state.user),
                  const SizedBox(height: 20),
                  const UserProfileSettingsSection(),
                  const SizedBox(height: 30),
                  const UserProfileLogoutButton(),
                  const SizedBox(height: 40),
                ],
              ),
            );
          }
          return const SizedBox(); // Initial state or other
        },
      ),
    );
  }
}
