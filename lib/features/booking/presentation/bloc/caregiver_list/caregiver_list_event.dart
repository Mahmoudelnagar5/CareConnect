import 'package:equatable/equatable.dart';

abstract class CaregiverListEvent extends Equatable {
  const CaregiverListEvent();
  @override
  List<Object?> get props => [];
}

class LoadCaregivers extends CaregiverListEvent {
  final String? query;
  final String? specialty;
  const LoadCaregivers({this.query, this.specialty});
  @override
  List<Object?> get props => [query, specialty];
}

class FilterCaregivers extends CaregiverListEvent {
  final String specialty;
  const FilterCaregivers(this.specialty);
  @override
  List<Object?> get props => [specialty];
}

class SearchCaregivers extends CaregiverListEvent {
  final String query;
  const SearchCaregivers(this.query);
  @override
  List<Object?> get props => [query];
}
