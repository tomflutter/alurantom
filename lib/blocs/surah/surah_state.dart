// blocs/surah/surah_state.dart
// BLoC states for Surah list management

part of '../surah_bloc.dart';

/// Base class for all Surah states
abstract class SurahState extends Equatable {
  const SurahState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded
class SurahInitial extends SurahState {
  const SurahInitial();
}

/// State while Surahs are being fetched from API
class SurahLoading extends SurahState {
  const SurahLoading();
}

/// State when Surahs are successfully loaded
class SurahLoaded extends SurahState {
  /// All surahs from the API (never filtered)
  final List<Surah> allSurahs;

  /// Currently displayed surahs (may be filtered by search)
  final List<Surah> displayedSurahs;

  /// Current search query (empty string means no search)
  final String searchQuery;

  const SurahLoaded({
    required this.allSurahs,
    required this.displayedSurahs,
    this.searchQuery = '',
  });

  /// Helper: is user currently searching?
  bool get isSearching => searchQuery.isNotEmpty;

  SurahLoaded copyWith({
    List<Surah>? allSurahs,
    List<Surah>? displayedSurahs,
    String? searchQuery,
  }) {
    return SurahLoaded(
      allSurahs: allSurahs ?? this.allSurahs,
      displayedSurahs: displayedSurahs ?? this.displayedSurahs,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allSurahs, displayedSurahs, searchQuery];
}

/// State when fetching fails
class SurahError extends SurahState {
  final String message;

  const SurahError(this.message);

  @override
  List<Object?> get props => [message];
}