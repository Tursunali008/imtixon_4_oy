import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:flutter/material.dart';
import 'package:imtixon_4_oy/services/auth_service.dart';

class AuthController with ChangeNotifier {
  final AuthFirebaseServices _firebaseAuthService = AuthFirebaseServices();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    await _firebaseAuthService.register(
      email: email,
      password: password,
    );
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _firebaseAuthService.login(
      email: email,
      password: password,
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
    notifyListeners();
  }

  User? get user {
    return auth.currentUser;
  }

  Future<void> updateProfilePicture(File imageFile) async {
    try {
      // Upload the file to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profile_pictures')
          .child(auth.currentUser!.uid);
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update the user's profile with the new photo URL
      await auth.currentUser!.updatePhotoURL(downloadUrl);

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      // Handle errors
      print('Error updating profile picture: $e');
    }
  }

  Future<void> updateProfile({required String displayName, required String phoneNumber}) async {
    try {
      // Update the user's display name
      await auth.currentUser!.updateDisplayName(displayName);

      // Update the user's phone number (if your authentication provider supports it)
      // FirebaseAuth does not directly support updating the phone number like display name and photo URL.
      // You'll need to use a different method, such as updating a user profile collection in Firestore.
      
      // For example, you might have a users collection in Firestore:
      // await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).update({
      //   'phoneNumber': phoneNumber,
      // });

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      // Handle errors
      print('Error updating profile: $e');
    }
  }
}
