import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coindrop/models/app_user.dart';

class UserDatabaseService {
  final String uid;
  UserDatabaseService({this.uid});

  // Create collection called 'brews'.
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid, name: snapshot.get('name'), email: snapshot.get('email'));
  }

  // Update User Data.
  Future updateUserData(String uid, String name, String email) async {
    return await userCollection
        .doc(uid)
        .set({'uid': uid, 'name': name, 'email': email});
  }

  // This stream notifies the Provider package of the updates in the Specific User Data.
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
