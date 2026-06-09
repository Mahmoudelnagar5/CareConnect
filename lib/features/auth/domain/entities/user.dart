import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  const User({required this.id, required this.name, required this.email, required this.phone, this.imageProfile});

  final String id;
  final String name;
  final String email;
  final String phone;
  final String? imageProfile;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }

  User copyWith({String? id, String? name, String? email, String? phone, String? imageProfile}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageProfile: imageProfile ?? this.imageProfile,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, imageProfile];
}
