import 'package:equatable/equatable.dart';

enum BookingStatus { pending, confirmed, inProgress, completed, cancelled }

class Booking extends Equatable {
  final String id;
  final String caregiverId;
  final String caregiverName;
  final String caregiverAvatarUrl;
  final String serviceType;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int durationHours;
  final double totalAmount;
  final BookingStatus status;
  final String address;
  final String? notes;

  const Booking({
    required this.id,
    required this.caregiverId,
    required this.caregiverName,
    required this.caregiverAvatarUrl,
    required this.serviceType,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.totalAmount,
    required this.status,
    required this.address,
    this.notes,
  });

  @override
  List<Object?> get props => [id, caregiverId, date, status];
}
