import 'package:equatable/equatable.dart';

import '../../../domain/entities/caregiver.dart';

enum CaregiverListStatus { initial, loading, success, failure }

class CaregiverListState extends Equatable {
  final CaregiverListStatus status;
  final List<Caregiver> caregivers;
  final String selectedSpecialty;
  final String searchQuery;
  final String? errorMessage;

  const CaregiverListState({
    this.status = CaregiverListStatus.initial,
    this.caregivers = const [],
    this.selectedSpecialty = 'All',
    this.searchQuery = '',
    this.errorMessage,
  });

  CaregiverListState copyWith({
    CaregiverListStatus? status,
    List<Caregiver>? caregivers,
    String? selectedSpecialty,
    String? searchQuery,
    String? errorMessage,
  }) {
    return CaregiverListState(
      status: status ?? this.status,
      caregivers: caregivers ?? this.caregivers,
      selectedSpecialty: selectedSpecialty ?? this.selectedSpecialty,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, caregivers, selectedSpecialty, searchQuery, errorMessage];
}
