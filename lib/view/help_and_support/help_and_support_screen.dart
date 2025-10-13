import 'package:e_learning/core/theme/app_color.dart';
import 'package:e_learning/view/help_and_support/widgets/contact_tile.dart';
import 'package:e_learning/view/help_and_support/widgets/faq_tile.dart';
import 'package:e_learning/view/help_and_support/widgets/help_search_bar.dart';
import 'package:e_learning/view/help_and_support/widgets/help_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'Help and Support',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
              const HelpSearchBar(),
              const SizedBox(height: 24),
              const HelpSection(
                title: 'Frequently Asked Question',
                children: [
                  FaqTile(
                    question: 'How do I reset my password?',
                    answer:
                        'Go to the login screen and tap "Forgot Password". Follow the instructions sent to your email.',
                  ),
                  FaqTile(
                    question: 'How can I change my email or phone number?',
                    answer:
                        'Open Settings > Account > Personal Info and update your email or phone number. We may ask you to verify the change.',
                  ),
                  FaqTile(
                    question: 'How do I update the app to the latest version?',
                    answer:
                        'Visit the App Store/Google Play, search for our app, and tap "Update". Keeping the app up to date ensures the best experience.',
                  ),
                  FaqTile(
                    question: 'Why didn’t I receive the verification email?',
                    answer:
                        'Please check your Spam/Junk folder and ensure you entered the correct email. If needed, tap "Resend" on the verification screen.',
                  ),
                  FaqTile(
                    question: 'How do I cancel my subscription?',
                    answer:
                        'Go to Settings > Subscription and follow the cancellation steps. If you subscribed via App Store/Google Play, manage it in your store settings.',
                  ),
                  FaqTile(
                    question: 'Do you offer refunds?',
                    answer:
                        'Refunds follow our policy and the rules of the payment platform used. Please contact support with your order ID for assistance.',
                  ),
                  FaqTile(
                    question: 'Can I use the app offline?',
                    answer:
                        'Some features may work offline, but certain content and sync actions require an internet connection.',
                  ),
                  FaqTile(
                    question: 'How do I delete my account and data?',
                    answer:
                        'Go to Settings > Privacy > Delete Account. This action is permanent and will remove your personal data where legally allowed.',
                  ),
                  FaqTile(
                    question: 'How can I export my data?',
                    answer:
                        'Request a data export via Settings > Privacy > Data Export. We will prepare a machine-readable file and notify you by email.',
                  ),
                  FaqTile(
                    question: 'My payment failed—what should I do?',
                    answer:
                        'Check that your card has sufficient funds, is enabled for online purchases, and matches your billing info. Try again or use another method.',
                  ),
                  FaqTile(
                    question: 'How do I report a bug or suggest a feature?',
                    answer:
                        'Use Settings > Help & Support > Send Feedback, or email support@yourapp.com with screenshots and a short description.',
                  ),
                  FaqTile(
                    question: 'What devices and OS versions are supported?',
                    answer:
                        'We support recent iOS and Android versions. For the best performance, keep your OS and the app updated to the latest stable release.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              HelpSection(
                title: 'Contact Us',
                children: [
                 ContactTile(
                   title: 'Email Support',
                   subtitle: 'Get help vie email',
                   icon: Icons.email_outlined,
                   onTap: () {},
                 ),
                  ContactTile(
                    title: 'Live Chat',
                    subtitle: 'Chat with our support team',
                    icon: Icons.chat_outlined,
                    onTap: () {},
                  ),
                  ContactTile(
                    title: 'Call Us',
                    subtitle: 'Speak with a representative',
                    icon: Icons.phone_outlined,
                    onTap: () {},
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
