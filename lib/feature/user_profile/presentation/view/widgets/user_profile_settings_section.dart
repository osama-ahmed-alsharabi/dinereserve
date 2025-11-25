import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/user_profile/presentation/view/widgets/user_profile_option.dart';
import 'package:flutter/material.dart';

class UserProfileSettingsSection extends StatelessWidget {
  const UserProfileSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader('Account Settings'),
        UserProfileOption(
          title: 'Personal Information',
          icon: Icons.person_outline,
          onTap: () {},
        ),
        UserProfileOption(
          title: 'My Orders',
          icon: Icons.receipt_long_outlined,
          onTap: () {},
        ),
        UserProfileOption(
          title: 'Payment Methods',
          icon: Icons.credit_card_outlined,
          onTap: () {},
        ),
        const SizedBox(height: 20),
        _buildSectionHeader('App Settings'),
        UserProfileOption(
          title: 'Notifications',
          icon: Icons.notifications_outlined,
          onTap: () {},
          trailing: Switch(
            value: true,
            onChanged: (val) {},
            activeColor: AppColors.primaryColor,
          ),
        ),
        UserProfileOption(
          title: 'Language',
          icon: Icons.language_outlined,
          onTap: () {},
          trailing: const Text(
            'English',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionHeader('Support'),
        UserProfileOption(
          title: 'Help Center',
          icon: Icons.help_outline,
          onTap: () {},
        ),
        UserProfileOption(
          title: 'Privacy Policy',
          icon: Icons.privacy_tip_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
