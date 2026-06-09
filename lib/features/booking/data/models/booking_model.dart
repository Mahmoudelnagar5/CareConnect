
import '../../domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.caregiverId,
    required super.caregiverName,
    required super.caregiverAvatarUrl,
    required super.serviceType,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.durationHours,
    required super.totalAmount,
    required super.status,
    required super.address,
    super.notes,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      caregiverId: json['caregiver_id'] as String,
      caregiverName: json['caregiver_name'] as String,
      caregiverAvatarUrl: json['caregiver_avatar_url'] as String? ?? '',
      serviceType: json['service_type'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      durationHours: json['duration_hours'] as int,
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      address: json['address'] as String,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'caregiver_id': caregiverId,
        'caregiver_name': caregiverName,
        'caregiver_avatar_url': caregiverAvatarUrl,
        'service_type': serviceType,
        'date': date.toIso8601String(),
        'start_time': startTime,
        'end_time': endTime,
        'duration_hours': durationHours,
        'total_amount': totalAmount,
        'status': status.name,
        'address': address,
        'notes': notes,
      };
}
