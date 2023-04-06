import 'package:flutter/material.dart';
import 'package:personalnotesapp/constants/routes.dart';
import 'package:personalnotesapp/services/auth/auth_service.dart';

class verifyEmailView extends StatefulWidget {
  const verifyEmailView({super.key});

  @override
  State<verifyEmailView> createState() => _verifyEmailViewState();
}

class _verifyEmailViewState extends State<verifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('verify email')),
      body: Column(
        children: [
          const Text(
              "we've sent you an email verification,please tap on the link to verify your account"),
          const Text(
              "if you haven't received a verification email yet ,tap the button below"),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('send email  verification'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('restart'),
          )
        ],
      ),
    );
  }
}
