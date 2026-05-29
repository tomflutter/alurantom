// screens/player_screen.dart
// Full-screen audio player for a single Surah

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/player_bloc.dart';
import '../utils/app_theme.dart';
import '../utils/duration_formatter.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              size: 32, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Now Playing',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is! PlayerActive) {
            return const Center(
              child: Text(
                'No Surah loaded',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            );
          }

          return _PlayerContent(state: state);
        },
      ),
    );
  }
}

class _PlayerContent extends StatelessWidget {
  final PlayerActive state;

  const _PlayerContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Surah artwork / icon
          _buildArtwork(),

          const Spacer(flex: 2),

          // Surah info
          _buildSurahInfo(),

          const SizedBox(height: 40),

          // Progress bar
          _buildProgressBar(context),

          const SizedBox(height: 32),

          // Playback controls
          _buildControls(context),

          const Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildArtwork() {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.accentGold.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentGold.withOpacity(0.08),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.surah.name,
            style: const TextStyle(
              color: AppTheme.accentGold,
              fontSize: 56,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Surah ${state.surah.number}',
              style: const TextStyle(
                color: AppTheme.accentGold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahInfo() {
    return Column(
      children: [
        Text(
          state.surah.englishName,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          state.surah.englishNameTranslation,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${state.surah.numberOfAyahs} Ayahs · ${state.surah.revelationType}',
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final position = state.position;
    final duration = state.duration ?? Duration.zero;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: state.progress,
            onChanged: (value) {
              if (duration.inMilliseconds > 0) {
                final seekTo = Duration(
                  milliseconds: (value * duration.inMilliseconds).round(),
                );
                context.read<PlayerBloc>().add(PlayerSeekRequested(seekTo));
              }
            },
            activeColor: AppTheme.accentGold,
            inactiveColor: AppTheme.divider,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DurationFormatter.format(position),
                style: const TextStyle(
                    color: AppTheme.textMuted, fontSize: 12),
              ),
              Text(
                DurationFormatter.format(duration),
                style: const TextStyle(
                    color: AppTheme.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    final isLoading = state.isLoading;
    final isPlaying = state.isPlaying;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Rewind 10s
        IconButton(
          onPressed: () {
            final newPos = state.position - const Duration(seconds: 10);
            context.read<PlayerBloc>().add(
                  PlayerSeekRequested(
                    newPos < Duration.zero ? Duration.zero : newPos,
                  ),
                );
          },
          icon: const Icon(Icons.replay_10_rounded),
          iconSize: 36,
          color: AppTheme.textSecondary,
        ),

        const SizedBox(width: 24),

        // Play / Pause button
        GestureDetector(
          onTap: () {
            if (isLoading) return;
            if (isPlaying) {
              context.read<PlayerBloc>().add(const PlayerPauseRequested());
            } else {
              context.read<PlayerBloc>().add(const PlayerResumeRequested());
            }
          },
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.accentGold,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentGold.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      color: AppTheme.backgroundDark,
                      strokeWidth: 2.5,
                    ),
                  )
                : Icon(
                    isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: AppTheme.backgroundDark,
                    size: 36,
                  ),
          ),
        ),

        const SizedBox(width: 24),

        // Forward 10s
        IconButton(
          onPressed: () {
            final duration = state.duration;
            if (duration == null) return;
            final newPos = state.position + const Duration(seconds: 10);
            context.read<PlayerBloc>().add(
                  PlayerSeekRequested(
                    newPos > duration ? duration : newPos,
                  ),
                );
          },
          icon: const Icon(Icons.forward_10_rounded),
          iconSize: 36,
          color: AppTheme.textSecondary,
        ),
      ],
    );
  }
}