import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AuthWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const AuthWidget(
      {super.key,
      required this.emailController,
      required this.passwordController});

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FTextField.email(
          controller: widget.emailController,
        ),
        const SizedBox(
          height: 10,
        ),
        FTextField.password(
          obscureText: !showPassword,
          controller: widget.passwordController,
          suffix: FButton.icon(
              style: FButtonStyle.ghost,
              onPress: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              child: FIcon(
                  !showPassword ? FAssets.icons.eye : FAssets.icons.eyeClosed)),
        ),
      ],
    );
  }
}
