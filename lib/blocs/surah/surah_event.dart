// blocs/surah/surah_event.dart

part of '../surah_bloc.dart'; // ← tambah ../

abstract class SurahEvent extends Equatable {
  const SurahEvent();

  @override
  List<Object?> get props => [];
}

class SurahLoadRequested extends SurahEvent {
  const SurahLoadRequested();
}

class SurahSearchChanged extends SurahEvent {
  final String query;

  const SurahSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SurahSearchCleared extends SurahEvent {
  const SurahSearchCleared();
}