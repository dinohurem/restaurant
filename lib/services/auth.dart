// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant/models/owner.dart';
import 'package:restaurant/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create doctor object based on Firebase user.
  Owner? _ownerFromFirebaseUser(User? user) {
    return user != null
        ? Owner(
            uid: user.uid,
            approved: true,
          )
        : null;
  }

  // Auth change user stream.
  Stream<Owner?> get owner {
    return _auth.authStateChanges().map(_ownerFromFirebaseUser);
  }

  // Sign in anonymously.
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _ownerFromFirebaseUser(user!);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  // Sign in with email/password.
  Future<Owner?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _ownerFromFirebaseUser(user!);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  // Register with email/password.
  Future registerWithEmailAndPassword(
      String email, String password, String restaurantName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Create a new document for the user with the uid and give some dummy data.
      await DatabaseService(uid: user!.uid).updateRestaurantData(
          restaurantName, const GeoPoint(0, 0), '', 0, '');

      return _ownerFromFirebaseUser(user);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  // Sign out.
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }
}
