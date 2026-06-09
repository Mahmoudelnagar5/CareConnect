import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSource({fb.FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Future<({String token, UserModel user})> login({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      final session = await _sessionFrom(credential.user);
      await _saveUserToFirestore(session.user);
      return session;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    } catch (_) {
      throw const AuthException('Unable to sign in. Please try again.');
    }
  }

  @override
  @override
  Future<({String token, UserModel user})> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? imageFilePath,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
      final user = _auth.currentUser ?? credential.user;
      final session = await _sessionFrom(user, nameOverride: name, phoneOverride: phone, imageOverride: imageFilePath);
      await _saveUserToFirestore(session.user);
      return session;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    } catch (_) {
      throw const AuthException('Unable to create your account. Please try again.');
    }
  }



  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    } catch (_) {
      throw const AuthException('Unable to send the reset email. Please try again.');
    }
  }

  @override
  Future<void> resetPassword({required String email, required String code, required String newPassword}) async {
    try {
      await _auth.confirmPasswordReset(code: code.trim(), newPassword: newPassword);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    } catch (_) {
      throw const AuthException('Unable to reset your password. Please try again.');
    }
  }

  Future<void> logout() => _auth.signOut();

  Future<({String token, UserModel user})?> currentSession() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final firestoreUser = await _getUserFromFirestore(user.uid);
    if (firestoreUser != null) {
      final token = await user.getIdToken() ?? '';
      return (token: token, user: firestoreUser);
    }
    return _sessionFrom(user);
  }

  Future<UserModel?> getUserProfile(String uId) async {
    try {
      final doc = await _firestore.collection('users').doc(uId).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toJson(), SetOptions(merge: true));
  }

  Future<UserModel?> _getUserFromFirestore(String uId) async {
    try {
      final doc = await _firestore.collection('users').doc(uId).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (_) {
      return null;
    }
  }

  Future<({String token, UserModel user})> _sessionFrom(fb.User? user, {String? nameOverride, String? phoneOverride, String? imageOverride}) async {
    if (user == null) {
      throw const AuthException('No authenticated user was returned.');
    }
    final token = await user.getIdToken() ?? '';
    return (
      token: token,
      user: UserModel(
        id: user.uid,
        name: nameOverride ?? user.displayName ?? '',
        email: user.email ?? '',
        phone: phoneOverride ?? user.phoneNumber ?? '',
        imageProfile: imageOverride ?? user.photoURL,
      ),
    );
  }

  String _messageFor(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection. Please try again.';
      case 'expired-action-code':
      case 'invalid-action-code':
        return 'This reset link is invalid or has expired.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
