import 'package:budget_tracker/services/dio_service.dart';
import 'package:budget_tracker/services/local_cache_service.dart';
import 'package:budget_tracker/values/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class AuthProvider extends ChangeNotifier {
  AuthMode _authMode = AuthMode.signUp;

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  AuthMode get authMode => _authMode;

  void toggleAuthMode() {
    _authMode = _authMode == AuthMode.signUp
        ? AuthMode.signIn
        : AuthMode.signUp;
    formKey.currentState!.reset();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (_authMode == AuthMode.signUp && password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Passwords must match.')));
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await DioService.instance.dio.post(
        _authMode == AuthMode.signUp ? '/v1/auth/signup' : '/v1/auth/signin',
        data: {"email": email, "password": password},
      );
      final data = response.data as Map<String, dynamic>;
      final authToken = data['data']['authToken'] as String;
      LocalCacheService.setString('authToken', authToken);
      DioService.setAuthToken();
      Phoenix.rebirth(context);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong.')));
      _isLoading = false;
      notifyListeners();
    }
  }
}
