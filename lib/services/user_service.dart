import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mxg/models/mxg_user.dart';

class UserService {
  final FirebaseFirestore firestore;
  late final CollectionReference<MxgUser> collection;

  UserService(this.firestore) {
    collection = firestore.collection('users').withConverter<MxgUser>(fromFirestore: (snapshot, _) =>
        MxgUser.fromJson(snapshot.data()!),
      toFirestore: (entry, _) => entry.toJson(),);
  }

  Future<void> addUser(MxgUser user) {
    return collection.doc(user.id).set(user);
  }

  Future<MxgUser?> getUser(String id) async {
    return (await collection.doc(id).get()).data();
  }
}