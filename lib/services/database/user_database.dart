import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coindrop/models/app_user.dart';

class UserDatabaseService {
  final String uid;
  UserDatabaseService({this.uid});

  // Create collection called 'brews'.
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  printData() async {
    final DocumentSnapshot docSnapshot = await userCollection.doc(uid).get();
    print(docSnapshot.get('name').toString());
  }

  // Convert QuerySnapshot to Brew List.
  // List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  // '??' checks if the is data is empty.
  //     return Brew(
  //       name: doc.get('name') ?? '',
  //       strength: doc.get('strength') ?? '',
  //       sugars: doc.get('sugars') ?? '',
  //     );
  //   }).toList();
  // }

  //
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.get('name'),
    );
  }

  // Update User Data.
  Future updateUserData(String name) async {
    return await userCollection.doc(uid).set({
      'name': name,
    });
  }

  // This stream notifies the Provider package of the updates in the database.
  // Stream<List<Brew>> get brews {
  //   return brewCollection.snapshots().map(_brewListFromSnapshot);
  // }

  // This stream notifies the Provider package of the updates in the Specific User Data.
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
