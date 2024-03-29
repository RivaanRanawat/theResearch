import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:research/common/auth_field.dart';
import 'package:research/common/loader.dart';
import 'package:research/features/auth/auth_controller.dart';
import 'package:research/theme/pallete.dart';
import 'package:research/utils.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Pallete.primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: isLoading
            ? const Loader()
            : Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Sign Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Please sign up to continue to Turn Pages and let the reading schedule begin!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 50),
                      AuthField(
                        controller: fullNameController,
                        labelText: 'Full Name',
                        icon: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AuthField(
                        controller: emailController,
                        labelText: 'Email',
                        icon: const Icon(
                          Icons.email_outlined,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AuthField(
                        controller: passwordController,
                        labelText: 'Password',
                        icon: const Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                        ),
                        isObscure: true,
                      ),
                      const SizedBox(height: 20),
                      AuthField(
                        controller: confirmPasswordController,
                        labelText: 'Confirm Password',
                        icon: const Icon(
                          Icons.lock_open,
                          color: Colors.white,
                        ),
                        isObscure: true,
                      ),
                      const SizedBox(height: 30),
                      Builder(
                        builder: (ctx) => MaterialButton(
                          minWidth: double.maxFinite,
                          height: 50,
                          elevation: 0,
                          onPressed: () {
                            if (passwordController.text ==
                                confirmPasswordController.text) {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .signUpUser(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    fullName: fullNameController.text,
                                    context: context,
                                  );
                            } else {
                              showSnackBar(
                                  context, 'The passwords don\'t match.');
                            }
                          },
                          color: Pallete.logoGreen,
                          textColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                GoRouter.of(context).push('/login');
                              },
                              child: const Text(
                                'Login?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
