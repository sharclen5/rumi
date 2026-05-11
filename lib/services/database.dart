import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference babyCollection = FirebaseFirestore.instance
      .collection('babies');

  Future updateUserData(
    String name,
    String gender,
    int age,
    int weight,
    int height,
  ) async {
    return await babyCollection.doc(uid).set({
      'name': name,
      'gender': gender,
      'age': age,
      'weight': weight,
      'height': height,
    });
  }

  // get baby stream
  Stream<QuerySnapshot> get babies {
    return babyCollection.snapshots();
  }
}
