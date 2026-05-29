// blocs/surah_bloc.dart
// Business logic for Surah list screen

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/surah.dart';
import '../repositories/quran_repository.dart';

part 'surah/surah_event.dart'; // ← ganti import jadi part
part 'surah/surah_state.dart'; // ← ganti import jadi part

class SurahBloc extends Bloc<SurahEvent, SurahState> {
  final QuranRepository _repository;

  SurahBloc({required QuranRepository repository})
      : _repository = repository,
        super(const SurahInitial()) {
    on<SurahLoadRequested>(_onLoadRequested);
    on<SurahSearchChanged>(_onSearchChanged);
    on<SurahSearchCleared>(_onSearchCleared);
  }

  /// Fetches all Surahs from the repository
  Future<void> _onLoadRequested(
    SurahLoadRequested event,
    Emitter<SurahState> emit,
  ) async {
    emit(const SurahLoading());
    try {
      final surahs = await _repository.fetchAllSurahs();
      emit(SurahLoaded(
        allSurahs: surahs,
        displayedSurahs: surahs,
        searchQuery: '',
      ));
    } catch (e) {
      emit(SurahError('Failed to load Surahs. Please check your connection.\n$e'));
    }
  }

  /// Filters displayed Surahs based on search query
  void _onSearchChanged(
    SurahSearchChanged event,
    Emitter<SurahState> emit,
  ) {
    final currentState = state;
    if (currentState is! SurahLoaded) return;

    final query = event.query.toLowerCase().trim();

    if (query.isEmpty) {
      emit(currentState.copyWith(
        displayedSurahs: currentState.allSurahs,
        searchQuery: '',
      ));
      return;
    }

    // Filter by english name, translation, arabic name, or surah number
    final filtered = currentState.allSurahs.where((surah) {
      return surah.englishName.toLowerCase().contains(query) ||
          surah.englishNameTranslation.toLowerCase().contains(query) ||
          surah.name.contains(event.query) ||
          surah.number.toString() == query;
    }).toList();

    emit(currentState.copyWith(
      displayedSurahs: filtered,
      searchQuery: event.query,
    ));
  }

  /// Resets search to show all Surahs
  void _onSearchCleared(
    SurahSearchCleared event,
    Emitter<SurahState> emit,
  ) {
    final currentState = state;
    if (currentState is! SurahLoaded) return;

    emit(currentState.copyWith(
      displayedSurahs: currentState.allSurahs,
      searchQuery: '',
    ));
  }
}