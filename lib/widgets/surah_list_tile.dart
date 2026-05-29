// widgets/surah_list_tile.dart
// A single Surah item in the list

import 'package:flutter/material.dart';
import '../models/surah.dart';
import '../utils/app_theme.dart';

class SurahListTile extends StatelessWidget {
  final Surah surah;
  final bool isPlaying;
  final VoidCallback onTap;

  const SurahListTile({
    super.key,
    required this.surah,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isPlaying
              ? AppTheme.accentGold.withOpacity(0.08)
              : AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPlaying ? AppTheme.accentGold.withOpacity(0.4) : AppTheme.divider,
            width: isPlaying ? 1.5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Surah number badge
              _SurahNumberBadge(number: surah.number, isPlaying: isPlaying),
              const SizedBox(width: 14),

              // Surah name info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // English name
                    Text(
                      surah.englishName,
                      style: TextStyle(
                        color: isPlaying
                            ? AppTheme.accentGoldLight
                            : AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // English translation
                    Text(
                      surah.englishNameTranslation,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Right side: Arabic name + verse count
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    surah.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${surah.numberOfAyahs} verses',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8),

              // Play indicator
              Icon(
                isPlaying ? Icons.graphic_eq_rounded : Icons.play_circle_outline_rounded,
                color: isPlaying ? AppTheme.accentGold : AppTheme.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Circular badge showing the Surah number
class _SurahNumberBadge extends StatelessWidget {
  final int number;
  final bool isPlaying;

  const _SurahNumberBadge({required this.number, required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPlaying
            ? AppTheme.accentGold.withOpacity(0.2)
            : AppTheme.backgroundElevated,
        border: Border.all(
          color: isPlaying ? AppTheme.accentGold : AppTheme.divider,
        ),
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
            color: isPlaying ? AppTheme.accentGoldLight : AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}