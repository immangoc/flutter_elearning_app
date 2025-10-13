import 'package:e_learning/bloc/font/font_bloc.dart';
import 'package:e_learning/bloc/font/font_event.dart';
import 'package:e_learning/core/theme/app_color.dart';
import 'package:e_learning/routes/app_routes.dart';
import 'package:e_learning/services/font_services.dart';
import 'package:e_learning/view/settings/widgets/setting_section.dart';
import 'package:e_learning/view/settings/widgets/setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Setting', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingSection(
                title: 'App Preferences',
                children: [
                  SettingTile(
                    title: 'Download over Wi-fi only',
                    icon: Icons.wifi_outlined,
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingSection(
                title: 'Content',
                children: [
                  SettingTile(
                    title: 'Content',
                    icon: Icons.high_quality_outlined,
                    trailing: DropdownButton<String>(
                      onChanged: (value) {},
                      underline: const SizedBox(),
                      value: 'High',
                      items: ['Low', 'Medium', 'High']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                    ),
                  ),
                  SettingTile(
                    title: 'Auto-plays Videos',
                    icon: Icons.play_circle_outline,
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingSection(
                title: 'Privacy',
                children: [
                  SettingTile(
                    title: 'Privacy Policy',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
                  ),
                  SettingTile(
                    title: 'Terms of Service',
                    icon: Icons.description_outlined,
                    onTap: () => Get.toNamed(AppRoutes.termsConditions),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingSection(
                title: 'Text Settings',
                children: [
                  SettingTile(
                    title: 'Font Size',
                    icon: Icons.format_size,
                    trailing: DropdownButton<String>(
                      value: FontService.currentFontScale == 0.8
                          ? 'Small'
                          : FontService.currentFontScale == 1.0
                          ? 'Normal'
                          : FontService.currentFontScale == 1.2
                          ? 'Large'
                          : 'Extra Large',
                      items: FontService.fontSizeScales.keys
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) async {
                        if (value != null) {
                          context.read<FontBloc>().add(
                            UpdateFontScale(FontService.fontSizeScales[value]!),
                          );
                        }
                      },
                      underline: const SizedBox(),
                    ),
                  ),
                  SettingTile(
                    title: 'Font Family',
                    icon: Icons.font_download,
                    trailing: DropdownButton<String>(
                      value: FontService.availableFonts.entries
                          .firstWhere(
                            (e) => e.value == FontService.currentFontFamily,
                          )
                          .key,
                      items: FontService.availableFonts.keys
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (value) async {
                        if (value != null) {
                          context.read<FontBloc>().add(
                            UpdateFontFamily(
                              FontService.availableFonts[value]!,
                            ),
                          );
                        }
                      },
                      underline: const SizedBox(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SettingSection(
                title: 'App Info',
                children: [
                  SettingTile(
                    title: 'Version',
                    icon: Icons.info_outline,
                    trailing: Text(
                      '1.0.0',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
