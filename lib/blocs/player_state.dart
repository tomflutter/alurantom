// blocs/player_state.dart
// States for the audio player BLoC

part of 'player_bloc.dart';

/// Playback status enum
enum PlayerStatus {
  initial,
  loading,
  playing,
  paused,
  completed,
  error,
}

/// Base class for all Player states
abstract class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object?> get props => [];
}

/// Player has not been used yet
class PlayerInitial extends PlayerState {
  const PlayerInitial();
}

/// Full player state with all playback info
class PlayerActive extends PlayerState {
  /// The currently loaded Surah
  final Surah surah;

  /// Current playback status
  final PlayerStatus status;

  /// Current playback position
  final Duration position;

  /// Total duration of the audio (null until known)
  final Duration? duration;

  /// Error message if status is error
  final String? errorMessage;

  const PlayerActive({
    required this.surah,
    required this.status,
    this.position = Duration.zero,
    this.duration,
    this.errorMessage,
  });

  /// Convenience getters
  bool get isPlaying => status == PlayerStatus.playing;
  bool get isPaused => status == PlayerStatus.paused;
  bool get isLoading => status == PlayerStatus.loading;
  bool get hasError => status == PlayerStatus.error;

  /// Progress as 0.0–1.0 (safe: returns 0 if duration unknown)
  double get progress {
    if (duration == null || duration!.inMilliseconds == 0) return 0.0;
    final value = position.inMilliseconds / duration!.inMilliseconds;
    return value.clamp(0.0, 1.0);
  }

  PlayerActive copyWith({
    Surah? surah,
    PlayerStatus? status,
    Duration? position,
    Duration? duration,
    String? errorMessage,
  }) {
    return PlayerActive(
      surah: surah ?? this.surah,
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [surah, status, position, duration, errorMessage];
}