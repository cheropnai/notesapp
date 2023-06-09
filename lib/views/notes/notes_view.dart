import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personalnotesapp/services/auth/auth_service.dart';
import 'package:personalnotesapp/services/crud/notes_service.dart';

import '../../constants/routes.dart';
import '../../enum/menu_Action.dart';
import '../../utilities/show_logout_dialog.dart';

class notesview extends StatefulWidget {
  const notesview({super.key});

  @override
  State<notesview> createState() => _notesviewState();
}

class _notesviewState extends State<notesview> {
  late final NotesService _notesService;
  String? get userEmail => AuthService.firebase().currentUser?.email;

  @override
  void initState() {
    _notesService = NotesService();
    // _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newNotesRoute);
              },
              icon: const Icon(Icons.add)),
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail ?? ''),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              print(snapshot.data);
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    //case ConnectionState.active:
                    //return const Text('am active and receiving notes');
                    case ConnectionState.done:
                      //print(snapshot.data);
                      return StreamBuilder(
                        stream: _notesService.allNotes,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return const Text('no connection');

                            case ConnectionState.waiting:
                            case ConnectionState.active:
                              if (snapshot.hasData) {
                                final allNotes =
                                    snapshot.data as List<databaseNotes>;
                                return ListView.builder(
                                    itemCount: allNotes.length,
                                    itemBuilder: (context, index) {
                                      final note = allNotes[index];
                                      return ListTile(title:Text( note.text,
                                      maxLines: 1,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,),);
                                    });
                              } else {
                                return const Text('item 1');
                              }
                            default:
                              return const CircularProgressIndicator();
                          }
                        },
                      );
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
