import 'package:flutter/material.dart';
import 'package:personalnotesapp/constants/routes.dart';
import 'package:personalnotesapp/services/auth/auth_exceptions.dart';
import 'package:personalnotesapp/services/auth/auth_service.dart';
import 'dart:developer' as devtools show log;

import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'enter your password here'),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase()
                      .createUser(email: email, password: password);
                  final User = AuthService.firebase().currentUser;
                  AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute, (route) => false);
                } on WeakPasswordAuthException{
                  await showErrorDialog(
                      context,
                      'weak password',);
                }
                
                on EmailAlreadyInUseAuthException{
                  await showErrorDialog(
                      context,
                      'email is already in use',
                    );
                }
                on InvalidEmailAuthException{
                  await showErrorDialog(
                      context,
                      'this is an invalid email address',
                    );
                }
                on GenericAuthException{
                   await showErrorDialog(
                    context,
                    'failed to register',
                  );
                }
                
                
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already registerd? login here!')),
        ],
      ),
    );
  }
}
