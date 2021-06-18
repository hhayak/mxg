import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mxg/models/mxg_user.dart';
import 'package:mxg/models/reminder.dart';

class UserService {
  final FirebaseFirestore firestore;
  late final CollectionReference<MxgUser> collection;
  late final DocumentReference<MxgUser> userDoc;
  late final String uid;

  UserService(this.firestore) {
    collection = firestore.collection('users').withConverter<MxgUser>(
          fromFirestore: (snapshot, _) => MxgUser.fromJson(snapshot.data()!),
          toFirestore: (entry, _) => entry.toJson(),
        );
  }

  void bind(String nuid) {
    uid = nuid;
    userDoc = collection.doc(nuid).withConverter<MxgUser>(
          fromFirestore: (snapshot, _) => MxgUser.fromJson(snapshot.data()!),
          toFirestore: (entry, _) => entry.toJson(),
        );
  }

  Future<void> addUser(MxgUser user) {
    return collection.doc(user.id).set(user);
  }

  Future<MxgUser?> getUser(String id) async {
    return (await collection.doc(id).get()).data();
  }

  Future<void> addReminder(Reminder reminder) async {
    return userDoc.update({'reminder': reminder.toJson()});
  }

  Future<void> deleteReminder(Reminder reminder) async {
    return userDoc.update({'reminder': null});
  }
}
