import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../features/auth/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel?> getProfile(String uId);
  Future<void> updateProfile(UserModel user);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<UserModel?> getProfile(String uId) async {
    final doc = await _firestore.collection('users').doc(uId).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  @override
  Future<void> updateProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toJson(), SetOptions(merge: true));
  }
}
