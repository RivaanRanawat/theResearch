import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:research/common/auth_field.dart';
import 'package:research/common/loader.dart';
import 'package:research/features/auth/auth_controller.dart';
import 'package:research/theme/pallete.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Enter your email and password below to continue to theResearch!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 50),
                      AuthField(
                        controller: emailController,
                        labelText: 'Email',
                        icon: const Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AuthField(
                        controller: passwordController,
                        labelText: 'Password',
                        icon: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        isObscure: true,
                      ),
                      const SizedBox(height: 30),
                      MaterialButton(
                        elevation: 0,
                        minWidth: double.maxFinite,
                        height: 50,
                        onPressed: () {
                          ref.read(authControllerProvider.notifier).loginUser(
                                email: emailController.text,
                                password: passwordController.text,
                                context: context,
                              );
                        },
                        color: Pallete.logoGreen,
                        textColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        elevation: 0,
                        minWidth: double.maxFinite,
                        height: 50,
                        onPressed: () {
                          // loginUser(type: LoginType.google, context: context);
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.google),
                            SizedBox(width: 10),
                            Text('Sign In using Google',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
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
                                GoRouter.of(context).push('/signup');
                              },
                              child: const Text(
                                'Sign Up?',
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
