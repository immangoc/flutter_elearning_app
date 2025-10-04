import 'package:e_learning/core/theme/app_color.dart';
import 'package:e_learning/view/profile/widgets/profile_app_bar.dart';
import 'package:e_learning/view/profile/widgets/profile_options.dart';
import 'package:e_learning/view/profile/widgets/profile_stats_card.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          ProfileAppBar(
            initials: 'MN',
            fullName: 'Ma Ngoc',
            email: 'immangoc@gmail.com',
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  ProfileStatsCard(),
                  SizedBox(height: 24),
                  ProfileOptions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
