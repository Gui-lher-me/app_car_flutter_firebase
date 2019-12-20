import 'package:firebase_auth/firebase_auth.dart';

class Auth {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> isLoggedIn(String email, String password)async {
    final AuthResult authResult = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
    final FirebaseUser firebaseUser = authResult.user;
    if (firebaseUser != null) {
      return true;
    }
    return false;
  }

  Future<String> getcurrentUserID()async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return user.uid;
  }

  Future<String> getcurrentUserEmail()async {
    FirebaseUser user = await firebaseAuth.currentUser();
    return user.email;
  }

  Future<void> logOut() => firebaseAuth.signOut();

}
