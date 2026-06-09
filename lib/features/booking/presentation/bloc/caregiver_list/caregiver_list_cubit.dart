import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_caregivers.dart';
import 'caregiver_list_state.dart';

class CaregiverListCubit extends Cubit<CaregiverListState> {
  final GetCaregivers getCaregivers;

  CaregiverListCubit(this.getCaregivers) : super(const CaregiverListState());

  Timer? _searchDebounce;

  Future<void> load({String? query, String? specialty}) async {
    await _fetch(query: query, specialty: specialty);
  }

  Future<void> filter(String specialty) async {
    emit(state.copyWith(selectedSpecialty: specialty));
    await _fetch(query: state.searchQuery, specialty: specialty);
  }

  /// Debounced search to avoid firing a request on every keystroke.
  void search(String query) {
    emit(state.copyWith(searchQuery: query));
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _fetch(query: query, specialty: state.selectedSpecialty);
    });
  }

  Future<void> _fetch({String? query, String? specialty}) async {
    emit(state.copyWith(status: CaregiverListStatus.loading));
    final result = await getCaregivers(GetCaregiversParams(query: query, specialty: specialty));
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(status: CaregiverListStatus.failure, errorMessage: failure.message)),
      (caregivers) => emit(state.copyWith(status: CaregiverListStatus.success, caregivers: caregivers)),
    );
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
