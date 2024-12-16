import 'package:chat/components/custom_text_form_field.dart';
import 'package:chat/providers/auth/auth_provider.dart';
import 'package:chat/screens/chats/chats_screen.dart';
import 'package:chat/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/primary_button.dart';
import '../../constants.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next is AuthSuccess) {
        NavigationUtil.navigateTo(
          context,
          const ChatsScreen(),
          clearStack: true,
        );
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }
    });

    final state = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
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
                  hintText: "Username",
                  prefixIcon: const Icon(Icons.person),
                  enabled: state is! AuthLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultPadding),
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: "Password",
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
                  enabled: state is! AuthLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultPadding * 1.5),
                PrimaryButton(
                  text: "Sign In",
                  isLoading: state is AuthLoading,
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(authProvider.notifier).signIn(
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
    super.dispose();
  }
}
