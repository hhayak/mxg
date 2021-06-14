import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mxg/models/weight_entry.dart';

class WeightEntryService {
  final FirebaseFirestore _firestore;
  late CollectionReference<WeightEntry> _collection;
  String? uid;

  WeightEntryService(this._firestore, this.uid) {
    var path = uid == null || uid!.isEmpty
        ? 'weight_entries'
        : 'users/$uid/weight_entries';
    _collection = _firestore.collection(path).withConverter<WeightEntry>(
          fromFirestore: (snapshot, _) =>
              WeightEntry.fromJson(snapshot.data()!),
          toFirestore: (entry, _) => entry.toJson(),
        );
  }

  void setUid(String nuid) {
    uid = nuid;
  }

  Future<WeightEntry?> getWeightEntry(String id) async {
    var docRef = await _collection.doc(id).get();
    return docRef.data();
  }

  Future<List<WeightEntry>> getUserWeightEntries() async {
    var query = await _collection.get();
    return query.docs.map((e) => e.data()).toList();
  }

  Future<void> addWeightEntry(WeightEntry entry) {
    var doc = _collection.doc();
    return doc
        .set(WeightEntry(weight: entry.weight, id: doc.id, date: entry.date));
  }

  Future<void> deleteWeightEntry(String id) {
    return _collection.doc(id).delete().onError((error, stackTrace) => null);
  }

  Stream<List<WeightEntry>> getUserWeightEntryStream() {
    var transformer = StreamTransformer<QuerySnapshot<WeightEntry>, List<WeightEntry>>.fromHandlers(handleData: (data, output) {
      output.add(data.docs.map((e) => e.data()).toList());
    });
    return _collection.snapshots().transform<List<WeightEntry>>(transformer);
  }
}
