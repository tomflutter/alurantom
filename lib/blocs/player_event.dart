// blocs/player_event.dart
// Events for the audio player BLoC

part of 'player_bloc.dart';

/// Base class for all Player events
abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

/// Load and start playing a Surah
class PlayerLoadSurah extends PlayerEvent {
  final Surah surah;

  const PlayerLoadSurah(this.surah);

  @override
  List<Object?> get props => [surah];
}

/// Pause the currently playing audio
class PlayerPauseRequested extends PlayerEvent {
  const PlayerPauseRequested();
}

/// Resume paused audio
class PlayerResumeRequested extends PlayerEvent {
  const PlayerResumeRequested();
}

/// Seek to a specific position
class PlayerSeekRequested extends PlayerEvent {
  final Duration position;

  const PlayerSeekRequested(this.position);

  @override
  List<Object?> get props => [position];
}

/// Internal: playback position updated (from stream)
class PlayerPositionUpdated extends PlayerEvent {
  final Duration position;

  const PlayerPositionUpdated(this.position);

  @override
  List<Object?> get props => [position];
}

/// Internal: total duration available (from stream)
class PlayerDurationUpdated extends PlayerEvent {
  final Duration duration;

  const PlayerDurationUpdated(this.duration);

  @override
  List<Object?> get props => [duration];
}

/// Internal: player status changed
class PlayerStatusChanged extends PlayerEvent {
  final PlayerStatus status;

  const PlayerStatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}

/// Stop and reset the player
class PlayerStopped extends PlayerEvent {
  const PlayerStopped();
}