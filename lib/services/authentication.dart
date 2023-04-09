import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Sign up with email and password
  Future<String?> signUpWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Add user data to Firestore
      User? user = await _firebaseAuth.currentUser;
      user?.updateDisplayName(displayName);
      await _db.collection('users').doc(user?.uid).set({
        'displayName': displayName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // Return null if no error occurs
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'The email address is already in use.'; // Return error message if email is already in use
      } else {
        errorMessage =
            'An error occurred. Please try again later.'; // Return generic error message for other errors
      }

      return errorMessage;
    }
  }

  // Log in with email and password
  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      }
      return errorMessage;
    }
  }

  // Log out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
