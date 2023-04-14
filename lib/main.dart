import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:personalnotesapp/constants/routes.dart';
import 'package:personalnotesapp/services/auth/auth_service.dart';
import 'package:personalnotesapp/utilities/show_error_dialog.dart';
import 'package:personalnotesapp/views/login_view.dart';
import 'package:personalnotesapp/views/notes/new_notes_view.dart';
import 'package:personalnotesapp/views/register_view.dart';
import 'package:personalnotesapp/views/verify_email_view.dart';

import 'dart:developer' as devtools show log;

import 'utilities/show_logout_dialog.dart';
import 'views/notes/notes_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const Homepage(),
    routes: {
      loginRoute: (context) => const Loginview(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const notesview(),
      newNotesRoute:(context)=> const newNotesView(),
    },
  ));
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final User = AuthService.firebase().currentUser;
            if (User != null) {
              if (User.isEmailVerified) {
                return const notesview();
              } else {
                return const verifyEmailView();
              }
            } else {
              return const Loginview();
            }
            

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
