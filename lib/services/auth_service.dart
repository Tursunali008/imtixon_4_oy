import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthFirebaseServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase SignIn Error: ${e.message}");
    } catch (e) {
      debugPrint("General SignIn error: $e");
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase SignIn Error: ${e.message}");
    } catch (e) {
      debugPrint("General SignIn error: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase SignOut error: $e");
    }
  }

  Future<void> updateProfilePicture(File imageFile) async {
    try {
      // Upload the file to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profile_pictures')
          .child(_firebaseAuth.currentUser!.uid);
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update the user's profile with the new photo URL
      await _firebaseAuth.currentUser!.updatePhotoURL(downloadUrl);
    } catch (e) {
      // Handle errors
      debugPrint('Error updating profile picture: $e');
    }
  }

  Future<void> updateProfile({
    required String displayName,
    required String phoneNumber,
  }) async {
    try {
      // Update the user's display name
      await _firebaseAuth.currentUser!.updateDisplayName(displayName);

      // Update the user's phone number in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update({'phoneNumber': phoneNumber});
    } catch (e) {
      // Handle errors
      debugPrint('Error updating profile: $e');
    }
  }
}
