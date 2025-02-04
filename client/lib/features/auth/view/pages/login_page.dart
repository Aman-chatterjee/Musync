import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musync/core/utils.dart';
import 'package:musync/core/widgets/loader.dart';
import 'package:musync/features/auth/view/pages/signup_page.dart';
import 'package:musync/features/auth/view/widgets/auth_field.dart';
import 'package:musync/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:musync/core/widgets/custom_field.dart';
import 'package:musync/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:musync/features/home/view/pages/home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  @override
  ConsumerState<LoginPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider)?.isLoading == true;
    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
          data: (data) {
            showSnackBar(context, 'Login successful');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (_) => false);
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {});
    });

    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            child: isLoading
                ? const Loader()
                : Padding(
                    padding: EdgeInsets.all(15),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign In.',
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          CustomField(
                            hintText: 'Email',
                            controller: emailController,
                            validator: (val) => checkEmail(val),
                          ),
                          const SizedBox(height: 30),
                          CustomField(
                            hintText: 'Password',
                            controller: passwordController,
                            isObscure: true,
                            validator: (val) => nullCheck(val, 'Password'),
                          ),
                          const SizedBox(height: 30),
                          AuthGradientButton(
                            label: 'Sign In',
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final email = emailController.text;
                                final password = passwordController.text;
                                await ref
                                    .read(authViewModelProvider.notifier)
                                    .loginUser(
                                      email: email.trim().toLowerCase(),
                                      password: password.trim(),
                                    );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          AuthField(
                            text1: 'Don\'t have an account? ',
                            text2: 'Sign Up',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ));
  }
}
