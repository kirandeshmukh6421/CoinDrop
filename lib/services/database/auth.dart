import 'package:coindrop/models/app_user.dart';
import 'package:coindrop/services/database/user_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Convert Firebase User to AppUser
  AppUser _userFromFirebaseUser(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // Auth Change User Stream [Notifies the Provider package of the User's Login Status continuously]
  Stream<AppUser> get user {
    return _auth
        .authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
    // .map(_userFromFirebaseUser(user));
  }

  // Register with Email and Password
  Future registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await UserDatabaseService(uid: user.uid).updateUserData(
        username,
      );
      return _userFromFirebaseUser(user);
    } catch (error) {
      String errorMessage = '';
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "email-already-in-use":
          errorMessage = "The email address is already in use.";
          break;

        default:
          errorMessage = "An undefined Error happened.";
      }
      print(error);
      return errorMessage;
    }
  }

  // Sign In with Email and Password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      String errorMessage = '';
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "user-not-found":
          errorMessage = "User not found.";
          break;
        case "wrong-password":
          errorMessage = "Wrong Password";
          break;
        default:
          errorMessage = "An undefined error happened.";
      }
      print(error);
      return errorMessage;
    }
  }

  // Sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
