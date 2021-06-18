import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> reload() async {
    var user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        await user.reload();
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<User?> authChanges() {
    return FirebaseAuth.instance.authStateChanges();
  }

  Future<User?> login(String email, String password) async {
    try {
      print('Logging in with: $email, $password');
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        throw 'Wrong password provided for that user.';
      }
      return null;
    }
  }

  Future<User?> signup(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        throw 'The account already exists for that email.';
      }
    }
  }

  Future<void> logout() async {
    return FirebaseAuth.instance.signOut();
  }
}
