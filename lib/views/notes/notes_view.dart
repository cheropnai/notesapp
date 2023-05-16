import 'package:flutter/material.dart';
import 'package:personalnotesapp/services/auth/auth_service.dart';
import 'package:personalnotesapp/services/cloud/cloud_note.dart';
import 'package:personalnotesapp/services/cloud/firebase_cloud_storage.dart';
import 'package:personalnotesapp/services/crud/notes_service.dart';
import 'package:personalnotesapp/views/notes/notes_list_view.dart';

import '../../constants/routes.dart';
import '../../enum/menu_Action.dart';
import '../../utilities/dialogs/logout_dialog.dart';
//import '../../utilities/show_logout_dialog.dart';

class notesview extends StatefulWidget {
  const notesview({super.key});

  @override
  State<notesview> createState() => _notesviewState();
}

class _notesviewState extends State<notesview> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();

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
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
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
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return notesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else
                return const CircularProgressIndicator();

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
