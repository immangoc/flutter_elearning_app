import 'package:e_learning/bloc/auth/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../core/utils/validators.dart';
import '../onboarding/widgets/common/custom_button.dart';
import '../onboarding/widgets/common/custom_textfield.dart';

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

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      // Show success dialog
      if(_formKey.currentState!.validate()){
        context.read<AuthBloc>().add(
          ForgotPasswordRequested(email: _emailController.text),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        } else if (!state.isLoading && state.error == null) {
          const SnackBar(
            content: Text('Password reset email sent successfully!'),
            backgroundColor: Colors.green,
          );

        }
      },

      child: Scaffold(
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

              // Email Field trong Form
              Form(
                key: _formKey,
                child: CustomTextfield(
                  label: 'Email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: FormValidator.validateEmail,
                ),
              ),

              const SizedBox(height: 30),

              // Reset Password Button
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return CustomButton(
                    text: 'Reset Password',
                    onPressed: _handleResetPassword,
                    isLoading: state.isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
