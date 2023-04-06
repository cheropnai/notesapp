
import 'package:flutter/material.dart';
import 'package:personalnotesapp/services/auth/auth_service.dart';

import '../constants/routes.dart';
import '../enum/menu_Action.dart';
import '../utilities/show_logout_dialog.dart';

class notesview extends StatefulWidget {
  const notesview({super.key});

  @override
  State<notesview> createState() => _notesviewState();
}

class _notesviewState extends State<notesview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  //devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                   await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('logout')),
              ];
            },
          )
        ],
      ),
      body: const Text('hello world'),
    );
  }
}
