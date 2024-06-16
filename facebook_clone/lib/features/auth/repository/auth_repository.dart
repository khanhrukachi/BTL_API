import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_clone/core/constants/firebase_collection_names.dart';
import 'package:facebook_clone/core/constants/firebase_field_names.dart';
import 'package:facebook_clone/core/constants/storage_folder_names.dart';
import 'package:facebook_clone/core/utils/utils.dart';
import 'package:facebook_clone/features/auth/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  // Sign in
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      showToastMessage(text: e.toString());
      return null;
    }
  }

  // Sign out
  Future<String?> signOut() async {
    try {
      await _auth.signOut();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Create account
  Future<UserCredential?> createAccount({
    required String fullName,
    required DateTime birthday,
    required String gender,
    required String email,
    required String password,
    required File? image,
  }) async {
    try {
      // Create an account in Firebase
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if user is null
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("User not found");
      }

      // Save image to Firebase Storage
      if (image != null) {
        final path = _storage
            .ref(StorageFolderNames.profilePics)
            .child(currentUser.uid);
        final taskSnapshot = await path.putFile(image);
        final downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Create UserModel
        UserModel user = UserModel(
          fullName: fullName,
          birthDay: birthday,
          gender: gender,
          email: email,
          password: password,
          profilePicUrl: downloadUrl,
          uid: currentUser.uid,
          friends: const [],
          sentRequests: const [],
          receivedRequests: const [],
        );

        // Save user to Firestore
        await _firestore
            .collection(FirebaseCollectionNames.users)
            .doc(currentUser.uid)
            .set(user.toMap());
      } else {
        throw Exception("Profile image is required");
      }

      return credential;
    } catch (e) {
      showToastMessage(text: e.toString());
      return null;
    }
  }

  // Verify Email
  Future<String?> verifyEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        await user.sendEmailVerification();
      }
      return null;
    } catch (e) {
      showToastMessage(text: e.toString());
      return e.toString();
    }
  }

  // Get user info
  Future<UserModel> getUserInfo() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("User not found");
      }

      final userData = await _firestore
          .collection(FirebaseCollectionNames.users)
          .doc(currentUser.uid)
          .get();

      if (!userData.exists) {
        throw Exception("User data not found");
      }

      final user = UserModel.fromMap(userData.data()!);
      return user;
    } catch (e) {
      showToastMessage(text: e.toString());
      rethrow;
    }
  }
}