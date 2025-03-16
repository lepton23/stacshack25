import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;

  User? get currentUser => _firebaseauth.currentUser;

  Stream<User?> get authStateChanges => _firebaseauth.authStateChanges();
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseauth.signInWithEmailAndPassword(email: email, password: password);
  }
  Future<void> signOut() async {
    await _firebaseauth.signOut();
  }
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    await _firebaseauth.createUserWithEmailAndPassword(email: email, password: password);
  }
  
}
