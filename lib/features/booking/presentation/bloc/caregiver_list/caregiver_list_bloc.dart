import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../domain/usecases/get_caregivers.dart';
import 'caregiver_list_event.dart';
import 'caregiver_list_state.dart';

EventTransformer<E> _debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class CaregiverListBloc extends Bloc<CaregiverListEvent, CaregiverListState> {
  final GetCaregivers getCaregivers;

  CaregiverListBloc(this.getCaregivers) : super(const CaregiverListState()) {
    on<LoadCaregivers>(_onLoad);
    on<FilterCaregivers>(_onFilter);
    on<SearchCaregivers>(_onSearch, transformer: _debounce(const Duration(milliseconds: 350)));
  }

  Future<void> _fetch(Emitter<CaregiverListState> emit, {String? query, String? specialty}) async {
    emit(state.copyWith(status: CaregiverListStatus.loading));
    final result = await getCaregivers(GetCaregiversParams(query: query, specialty: specialty));
    result.fold(
      (failure) => emit(state.copyWith(status: CaregiverListStatus.failure, errorMessage: failure.message)),
      (caregivers) => emit(state.copyWith(status: CaregiverListStatus.success, caregivers: caregivers)),
    );
  }

  Future<void> _onLoad(LoadCaregivers event, Emitter<CaregiverListState> emit) async {
    await _fetch(emit, query: event.query, specialty: event.specialty);
  }

  Future<void> _onFilter(FilterCaregivers event, Emitter<CaregiverListState> emit) async {
    emit(state.copyWith(selectedSpecialty: event.specialty));
    await _fetch(emit, query: state.searchQuery, specialty: event.specialty);
  }

  Future<void> _onSearch(SearchCaregivers event, Emitter<CaregiverListState> emit) async {
    emit(state.copyWith(searchQuery: event.query));
    await _fetch(emit, query: event.query, specialty: state.selectedSpecialty);
  }
}
