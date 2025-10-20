import 'package:e_learning/bloc/auth/auth_bloc.dart';
import 'package:e_learning/bloc/auth/auth_event.dart';
import 'package:e_learning/bloc/auth/auth_state.dart';
import 'package:e_learning/core/utils/validators.dart';
import 'package:e_learning/view/onboarding/widgets/common/custom_button.dart';
import 'package:e_learning/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      context.read<AuthBloc>().add(ForgotPasswordRequested(email: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
      previous.error != current.error ||
          previous.passwordResetEmailSent != current.passwordResetEmailSent,
      listener: (context, state) {
        if (state.error != null && state.error!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state.passwordResetEmailSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset email sent! Please check your inbox.'),
              backgroundColor: Colors.green,
            ),
          );
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) Get.back();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter your email address to reset your password.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 10),

                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextfield(
                    label: 'Email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: FormValidator.validateEmail,
                  ),
                ),

                const SizedBox(height: 30),
                CustomButton(
                  text: 'Reset Password',
                  //
                  onPressed: state.isLoading
                      ? () {}
                      : () => _handleResetPassword(context),
                  isLoading: state.isLoading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
