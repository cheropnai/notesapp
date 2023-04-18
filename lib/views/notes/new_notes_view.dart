import 'package:flutter/material.dart';
import 'package:personalnotesapp/services/crud/notes_service.dart';

import '../../services/auth/auth_service.dart';

class newNotesView extends StatefulWidget {
  const newNotesView({super.key});

  @override
  State<newNotesView> createState() => _newNotesViewState();
}

class _newNotesViewState extends State<newNotesView> {
  databaseNotes? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;
  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNotes(note: note, text: text);
  }

  void setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener); 
  }

  Future<databaseNotes> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNotes(id: note.id);
    }
  }

  void _saveNotIfTextIsNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNotes(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNotIfTextIsNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('create a new note'),
      ),
      body: const Text('write your new note here ...'),
    );
  }
}
