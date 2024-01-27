// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:research/theme/pallete.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget icon;
  final bool isObscure;
  const AuthField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isObscure = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Pallete.secondaryColor,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          icon: icon,
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        // onFieldSubmitted: (_) => focusNode.requestFocus(),
        obscureText: isObscure,
      ),
    );
  }
}
