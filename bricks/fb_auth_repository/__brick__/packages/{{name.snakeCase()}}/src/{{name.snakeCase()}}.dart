// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_auth/firebase_auth.dart';

import '../../{{name.snakeCase()}}/src/models/auth_failure.dart';

/// Firaebause API Eception
class {{name.pascalCase()}}Failure implements Exception {
  ///
  const {{name.pascalCase()}}Failure([
    this.message = 'An unknown exception occurred',
    this.code = 'An unknown exeption code',
    this.plugin = 'An unknown plugin exception',
  ]);

  /// error message
  final String message;

  /// error code
  final String code;

  /// error plugin
  final String plugin;

  @override
  String toString() =>
      'FirebaseAuthApiFailure(message: $message, code: $code, plugin: $plugin)';
}

/// Authentication Repository

class {{name.snakeCase()}} {
  ///
  {{name.snakeCase()}}({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  ///
  final FirebaseFirestore firebaseFirestore;

  ///
  final fb_auth.FirebaseAuth firebaseAuth;

  ///
  final usersRef = FirebaseFirestore.instance.collection('user');

  ///
  Stream<fb_auth.User?> get user => firebaseAuth.userChanges();

  Future<void> currentUserChangeListener() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      FirebaseAuth.instance.currentUser?.reload();

      if (user == null) {
        // isLoggedin.value = false;
        // token.value = '';

        // if (Get.currentRoute != Routes.signin) {
        //   signOut();
        //   Get.offAllNamed(Routes.signin);
        // }
      } else {
        // isLoggedin.value = true;
        // userId.value = user.uid;
      }
    });
  }

  /// Firebase Signup
  Future<void> signup({
    required String firstName,
    String? lastName = '',
    String? age = '',
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final signedInUser = userCredential.user!;

      await usersRef.doc(signedInUser.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'email': email,
        'profileImage': 'https://picsum.photos/300',
        'point': 0,
        'rank': 'bronze',
      });
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    } catch (e) {
      throw AuthFailure(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  /// Signin
  Future<UserCredential?> signin({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on fb_auth.FirebaseAuthException catch (e) {
      // throw FirebaseAuthApiFailure(e.message.toString());

      throw AuthFailure(
        code: e.code,
        message: e.message,
        plugin: e.plugin,
      );
    } catch (e) {
      throw AuthFailure(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  /// Sign out
  Future<bool> signout() async {
    try {
      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    await firebaseAuth.currentUser?.updatePhotoURL(photoUrl);
  }
}
