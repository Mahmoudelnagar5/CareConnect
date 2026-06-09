import 'package:equatable/equatable.dart';

class Caregiver extends Equatable {
  final String id;
  final String name;
  final String avatarUrl;
  final String specialty;
  final double rating;
  final int reviewCount;
  final int yearsExperience;
  final double hourlyRate;
  final List<String> skills;
  final String bio;
  final bool isAvailable;
  final String location;

  const Caregiver({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.yearsExperience,
    required this.hourlyRate,
    required this.skills,
    required this.bio,
    required this.isAvailable,
    required this.location,
  });

  @override
  List<Object?> get props => [id, name, specialty, rating, hourlyRate];
}
