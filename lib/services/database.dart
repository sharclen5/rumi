import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumi/models/baby.dart';
import 'package:rumi/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // reference to user's profile document
  DocumentReference get userDocument =>
      FirebaseFirestore.instance.collection('users').doc(uid);

  // save or update user profile
  Future updateUserProfile(
    String firstName,
    String lastName,
    String phone,
    String gender,
    String email,
  ) async {
    return await userDocument.set({
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'gender': gender,
      'email': email,
    }, SetOptions(merge: true));
  }

  // update user profile photo
  Future updateProfilePicture(String base64Image) async {
    return await userDocument.set({
      'photoUrl': base64Image,
    }, SetOptions(merge: true));
  }

  // convert snapshot to UserProfile object
  UserProfile? _userProfileFromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) return null;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserProfile(
      uid: uid,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phone: data['phone'] ?? '',
      gender: data['gender'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
    );
  }

  // get user profile as a stream (auto-updates if data changes)
  Stream<UserProfile?> get userProfile {
    return userDocument.snapshots().map(_userProfileFromSnapshot);
  }

  // reference to user's baby subcollection
  CollectionReference get babyCollection => FirebaseFirestore.instance
      .collection('babies')
      .doc(uid)
      .collection('babyList');

  // add a new baby
  Future addBaby(
    String firstName,
    String? middleName,
    String lastName,
    String gender,
    DateTime dateOfBirth,
    double weight,
    double height,
  ) async {
    return await babyCollection.add({
      'firstName': firstName,
      if (middleName != null && middleName.isNotEmpty) 'middleName': middleName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'weight': weight,
      'height': height,
    });
  }

  // update existing baby
  Future updateBaby(
    String babyId,
    String firstName,
    String? middleName,
    String lastName,
    String gender,
    DateTime dateOfBirth,
    double weight,
    double height,
  ) async {
    return await babyCollection.doc(babyId).set({
      'firstName': firstName,
      if (middleName != null && middleName.isNotEmpty) 'middleName': middleName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'weight': weight,
      'height': height,
    });
  }

  // delete a baby
  Future deleteBaby(String babyId) async {
    return await babyCollection.doc(babyId).delete();
  }

  // baby list from snapshot
  List<Baby> _babyListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Baby(
        id: doc.id,
        firstName: data['firstName'] ?? '',
        middleName: data['middleName'] ?? '',
        lastName: data['lastName'] ?? '',
        gender: data['gender'] ?? '',
        dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
        weight: (data['weight'] as num).toDouble(),
        height: (data['height'] as num).toDouble(),
      );
    }).toList();
  }

  // get babies stream (only current user's babies)
  Stream<List<Baby>> get babies {
    return babyCollection.snapshots().map(_babyListFromSnapshot);
  }
}
