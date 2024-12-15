import 'package:chat/components/custom_text_form_field.dart';
import 'package:chat/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

import '../../components/primary_button.dart';
import '../../constants.dart';
import '../../utils/navigation_util.dart';
import 'signin_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Listen to state changes
    ref.listen(authProvider, (previous, next) {
      if (next is AuthSuccess) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.response.message),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to login screen
        NavigationUtil.navigateTo(
          context,
          const SignInScreen(),
          transitionType: PageTransitionType.rightToLeft,
          clearStack: true,
        );
      } else if (next is AuthError) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    // Watch the current state
    final state = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(),
                CustomTextFormField(
                  controller: _usernameController,
                  hintText: "Choose a username",
                  prefixIcon: const Icon(Icons.person),
                  enabled: state is! AuthLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultPadding),
                CustomTextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  hintText: "Create password",
                  prefixIcon: const Icon(Icons.lock),
                  enabled: state is! AuthLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultPadding),
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  hintText: "Confirm password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  obscureText: true,
                  enabled: state is! AuthLoading,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultPadding * 1.5),
                PrimaryButton(
                  text: "Sign Up",
                  isLoading: state is AuthLoading,
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(authProvider.notifier).signUp(
                            _usernameController.text,
                            _passwordController.text,
                          );
                    }
                  },
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
