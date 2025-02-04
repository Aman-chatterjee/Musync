import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musync/core/utils.dart';
import 'package:musync/core/widgets/loader.dart';
import 'package:musync/features/auth/view/pages/login_page.dart';
import 'package:musync/features/auth/view/widgets/auth_field.dart';
import 'package:musync/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:musync/core/widgets/custom_field.dart';
import 'package:musync/features/auth/viewmodel/auth_viewmodel.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(authViewModelProvider.select((val) => val?.isLoading == true));
    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
          data: (data) {
            showSnackBar(
                context, 'Account created successfully, Please Login.');
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
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
                ? Loader()
                : Padding(
                    padding: EdgeInsets.all(15),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          CustomField(
                            hintText: 'Name',
                            controller: nameController,
                            validator: (val) => nullCheck(val, 'Name'),
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
                            label: 'Sign Up.',
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await ref
                                    .read(authViewModelProvider.notifier)
                                    .signUpUser(
                                      name: nameController.text,
                                      email: emailController.text
                                          .trim()
                                          .toLowerCase(),
                                      password: passwordController.text.trim(),
                                    );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          AuthField(
                            text1: 'Already have an account? ',
                            text2: 'Sign In',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
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
