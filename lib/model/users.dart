import 'package:cloud_firestore/cloud_firestore.dart';

class UserModels {
  final String id;
  final String token;
  final String name;
  final String email;

  UserModels({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  // Factory constructor to create a UserModels instance from Firestore document
  factory UserModels.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModels(
      id: doc.id,
      name: data["user-name"] ?? '', // Defaulting to empty string if null
      token: data["user-token"] ?? '',
      email: data["user-email"] ?? '',
    );
  }

  // Method to convert UserModels instance to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'user-name': name,
      'user-token': token,
      'user-email': email,
    };
  }
}
Future<UserModels> getUserData(String userId) async {
  DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .get();

  if (userDoc.exists) {
    return UserModels.fromJson(userDoc);
  } else {
    throw Exception('User not found');
  }
}

Future<void> saveUserData(UserModels user) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.id)
      .set(user.toJson());
}
