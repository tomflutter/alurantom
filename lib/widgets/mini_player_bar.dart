// widgets/mini_player_bar.dart
// Persistent mini player shown at the bottom of the Surah list

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/player_bloc.dart';
import '../utils/app_theme.dart';
import '../utils/duration_formatter.dart';
import '../screens/player_screen.dart';

class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state is! PlayerActive) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PlayerScreen()),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentGold.withOpacity(0.08),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // Surah number indicator
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.accentGold.withOpacity(0.15),
                      ),
                      child: Center(
                        child: Text(
                          '${state.surah.number}',
                          style: const TextStyle(
                            color: AppTheme.accentGold,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Surah name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.surah.englishName,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            state.isLoading
                                ? 'Loading...'
                                : '${DurationFormatter.format(state.position)} / ${state.duration != null ? DurationFormatter.format(state.duration!) : '--:--'}',

                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Play/Pause button
                    _MiniPlayPauseButton(state: state),
                  ],
                ),

                // Progress bar
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: state.isLoading ? null : state.progress,
                    backgroundColor: AppTheme.divider,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppTheme.accentGold),
                    minHeight: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MiniPlayPauseButton extends StatelessWidget {
  final PlayerActive state;

  const _MiniPlayPauseButton({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const SizedBox(
        width: 36,
        height: 36,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppTheme.accentGold,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (state.isPlaying) {
          context.read<PlayerBloc>().add(const PlayerPauseRequested());
        } else {
          context.read<PlayerBloc>().add(const PlayerResumeRequested());
        }
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.accentGold,
        ),
        child: Icon(
          state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: AppTheme.backgroundDark,
          size: 20,
        ),
      ),
    );
  }
}