// blocs/player_bloc.dart
// Core audio playback BLoC using just_audio

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import '../models/surah.dart';

part 'player_event.dart';
part 'player_state.dart';

/// BLoC managing all audio playback functionality.
///
/// Uses [just_audio] package for audio streaming.
/// Handles:
/// - Loading and playing Surah audio from URL
/// - Pause / Resume
/// - Seeking to specific positions
/// - Real-time position and duration updates
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioPlayer _audioPlayer;

  /// Subscriptions to just_audio streams
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  PlayerBloc({AudioPlayer? audioPlayer})
      : _audioPlayer = audioPlayer ?? AudioPlayer(),
        super(const PlayerInitial()) {
    on<PlayerLoadSurah>(_onLoadSurah);
    on<PlayerPauseRequested>(_onPause);
    on<PlayerResumeRequested>(_onResume);
    on<PlayerSeekRequested>(_onSeek);
    on<PlayerPositionUpdated>(_onPositionUpdated);
    on<PlayerDurationUpdated>(_onDurationUpdated);
    on<PlayerStatusChanged>(_onStatusChanged);
    on<PlayerStopped>(_onStopped);

    _initStreams();
  }

  /// Subscribe to just_audio event streams and forward as BLoC events
  void _initStreams() {
    // Position updates (fires ~every 200ms during playback)
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      add(PlayerPositionUpdated(position));
    });

    // Duration becomes available once audio is loaded
    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        add(PlayerDurationUpdated(duration));
      }
    });

    // Map just_audio processing states to our PlayerStatus
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        add(const PlayerStatusChanged(PlayerStatus.completed));
      }
    });
  }

  /// Load a Surah audio URL and begin playback
  Future<void> _onLoadSurah(
    PlayerLoadSurah event,
    Emitter<PlayerState> emit,
  ) async {
    // Emit loading state immediately
    emit(PlayerActive(
      surah: event.surah,
      status: PlayerStatus.loading,
    ));

    try {
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(event.surah.audioUrl);
      await _audioPlayer.play();

      emit(PlayerActive(
        surah: event.surah,
        status: PlayerStatus.playing,
        duration: _audioPlayer.duration,
      ));
    } catch (e) {
      emit(PlayerActive(
        surah: event.surah,
        status: PlayerStatus.error,
        errorMessage: 'Failed to load audio: $e',
      ));
    }
  }

  /// Pause playback
  Future<void> _onPause(
    PlayerPauseRequested event,
    Emitter<PlayerState> emit,
  ) async {
    final current = state;
    if (current is! PlayerActive) return;

    await _audioPlayer.pause();
    emit(current.copyWith(status: PlayerStatus.paused));
  }

  /// Resume paused playback
  Future<void> _onResume(
    PlayerResumeRequested event,
    Emitter<PlayerState> emit,
  ) async {
    final current = state;
    if (current is! PlayerActive) return;

    await _audioPlayer.play();
    emit(current.copyWith(status: PlayerStatus.playing));
  }

  /// Seek to a specific position in the audio
  Future<void> _onSeek(
    PlayerSeekRequested event,
    Emitter<PlayerState> emit,
  ) async {
    final current = state;
    if (current is! PlayerActive) return;

    await _audioPlayer.seek(event.position);
    emit(current.copyWith(position: event.position));
  }

  /// Update current playback position (from stream)
  void _onPositionUpdated(
    PlayerPositionUpdated event,
    Emitter<PlayerState> emit,
  ) {
    final current = state;
    if (current is! PlayerActive) return;
    emit(current.copyWith(position: event.position));
  }

  /// Update total duration (from stream)
  void _onDurationUpdated(
    PlayerDurationUpdated event,
    Emitter<PlayerState> emit,
  ) {
    final current = state;
    if (current is! PlayerActive) return;
    emit(current.copyWith(duration: event.duration));
  }

  /// Handle player status changes
  void _onStatusChanged(
    PlayerStatusChanged event,
    Emitter<PlayerState> emit,
  ) {
    final current = state;
    if (current is! PlayerActive) return;
    emit(current.copyWith(status: event.status));
  }

  /// Stop playback entirely
  Future<void> _onStopped(
    PlayerStopped event,
    Emitter<PlayerState> emit,
  ) async {
    await _audioPlayer.stop();
    emit(const PlayerInitial());
  }

  @override
  Future<void> close() async {
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _audioPlayer.dispose();
    return super.close();
  }
}