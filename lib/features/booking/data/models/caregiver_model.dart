import '../../domain/entities/caregiver.dart';

class CaregiverModel extends Caregiver {
  const CaregiverModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
    required super.specialty,
    required super.rating,
    required super.reviewCount,
    required super.yearsExperience,
    required super.hourlyRate,
    required super.skills,
    required super.bio,
    required super.isAvailable,
    required super.location,
  });

  factory CaregiverModel.fromJson(Map<String, dynamic> json) {
    return CaregiverModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String? ?? '',
      specialty: json['specialty'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int? ?? 0,
      yearsExperience: json['years_experience'] as int? ?? 0,
      hourlyRate: (json['hourly_rate'] as num).toDouble(),
      skills: (json['skills'] as List<dynamic>? ?? []).map((e) => e as String).toList(),
      bio: json['bio'] as String? ?? '',
      isAvailable: json['is_available'] as bool? ?? true,
      location: json['location'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatar_url': avatarUrl,
    'specialty': specialty,
    'rating': rating,
    'review_count': reviewCount,
    'years_experience': yearsExperience,
    'hourly_rate': hourlyRate,
    'skills': skills,
    'bio': bio,
    'is_available': isAvailable,
    'location': location,
  };
}
