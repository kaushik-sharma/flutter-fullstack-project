import 'package:budget_tracker/controllers/auth_provider.dart';
import 'package:budget_tracker/values/enums.dart';
import 'package:budget_tracker/widgets/overlay_loader.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(),
      builder: (context, child) => Consumer<AuthProvider>(
        builder: (context, provider, child) => OverlayLoader(
          showLoader: provider.isLoading,
          child: Scaffold(
            appBar: AppBar(title: Text('Expense Tracker')),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: provider.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        controller: provider.emailController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          if (!EmailValidator.validate(value.trim())) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: provider.passwordController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          if (value.trim().length < 8) {
                            return 'Length must be at-least 8 characters';
                          }
                          return null;
                        },
                        label: 'Password',
                        keyboardType: TextInputType.text,
                        obscureText: true,
                      ),
                      if (provider.authMode == AuthMode.signUp) ...[
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: provider.confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            if (value.trim().length < 8) {
                              return 'Length must be at-least 8 characters';
                            }
                            return null;
                          },
                          label: 'Confirm Password',
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                      ],
                      SizedBox(height: 25),
                      CustomButton(
                        onPressed: () {
                          provider.submitForm(context);
                        },
                        text: provider.authMode == AuthMode.signUp
                            ? 'Sign-up'
                            : 'Sign-in',
                      ),
                      SizedBox(height: 30),
                      CustomTextButton(
                        onPressed: provider.toggleAuthMode,
                        text: provider.authMode == AuthMode.signUp
                            ? 'Existing user? Sign-in'
                            : 'New user? Create account',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
