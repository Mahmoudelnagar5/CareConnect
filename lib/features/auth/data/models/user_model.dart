import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.imageProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['uId'] as String? ?? json['id'] as String,
      name: json['name'] as String? ?? json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      imageProfile: json['imageProfile'] as String? ?? json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': id,
      'name': name,
      'email': email,
      'phone': phone,
      'imageProfile': imageProfile,
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      id: data['uId'] as String? ?? doc.id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      imageProfile: data['imageProfile'] as String?,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      imageProfile: user.imageProfile,
    );
  }
}
