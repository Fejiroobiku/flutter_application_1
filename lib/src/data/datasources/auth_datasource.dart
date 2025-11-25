import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:here_bro/src/data/models/user.dart';

class AuthDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthDataSource({
    required this.firebaseAuth,
    required this.firestore,
  });

  Future<UserCredential> login(String email, String password) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register(
    String email,
    String password,
    String name,
  ) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
      'name': name,
      'createdAt': DateTime.now(),
    });

    return userCredential;
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  Future<User?> getCurrentUser() async {
    return firebaseAuth.currentUser;
  }

  Future<bool> isUserLoggedIn() async {
    return firebaseAuth.currentUser != null;
  }
}