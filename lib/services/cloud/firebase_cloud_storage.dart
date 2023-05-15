import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personalnotesapp/services/cloud/cloud_note.dart';
import 'package:personalnotesapp/services/cloud/cloud_storage_constants.dart';

import 'cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');
  

  Future<void> updateNote(
      {required String documentId, required String text}) async {
    try {
     await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException;
    }
  }
  Future<void> deleteNote(
      {required String documentId, required String text}) async {
    try {
     await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException;
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((value) => value.docs.map((doc) {
                return CloudNote(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  text: doc.data()[textFieldName] as String,
                );
              }));
    } catch (e) {
      throw CouldNotGetAllNotesException;
    }
  }

  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
  }

  //creating a singleton
  //first create a private constructor
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();
  //then create a factory constructor
  factory FirebaseCloudStorage() => _shared;
}