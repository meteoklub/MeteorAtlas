import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meteoapp/domain/models/user.dart';
import 'package:meteoapp/repositories/user_repository.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<User?> signInWithEmailAndPassword(
      String? email, String? password) async {
    try {
      if (email != null && password != null) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        UserRepository().setUser(_auth.currentUser);
      }
      return _auth.currentUser;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    UserRepository().setUser(null);
    await FirebaseAuth.instance.signOut();
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? currentUser = _auth.currentUser;
      final token = await _firebaseMessaging.getToken();
      if (currentUser != null) {
        UserRepository().setUser(_auth.currentUser);
        await _firestore.collection('users').doc(currentUser.uid).set({
          'email': currentUser.email,
          'token': token,
          'uid': currentUser.uid,
        });
      }
      return currentUser;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateTokenInDatabase(String newToken) async {
    try {
      String userId = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(userId).update({
        'tokens': FieldValue.arrayUnion([newToken]),
      });
    } catch (e) {
      // Handle the error, if needed
    }
  }
}
