  // screens/surah_list_screen.dart
  // Main screen showing list of all Surahs with search

  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import '../blocs/surah_bloc.dart';
  import '../blocs/player_bloc.dart';
  import '../models/surah.dart';
  import '../utils/app_theme.dart';
  import '../widgets/surah_list_tile.dart';
  import '../widgets/mini_player_bar.dart';
  import '../widgets/shimmer_list.dart';
  import '../screens/player_screen.dart'; // ← tambahkan ini


  class SurahListScreen extends StatefulWidget {
    const SurahListScreen({super.key});

    @override
    State<SurahListScreen> createState() => _SurahListScreenState();
  }

  class _SurahListScreenState extends State<SurahListScreen> {
    final TextEditingController _searchController = TextEditingController();
    final ScrollController _scrollController = ScrollController();

    @override
    void initState() {
      super.initState();
      // Load all Surahs when screen initializes
      context.read<SurahBloc>().add(const SurahLoadRequested());
    }

    @override
    void dispose() {
      _searchController.dispose();
      _scrollController.dispose();
      super.dispose();
    }

    void _onSurahTapped(Surah surah) {
      // Start playback
      context.read<PlayerBloc>().add(PlayerLoadSurah(surah));

      // Navigate to full player screen
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const PlayerScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            );
          },
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: Column(
          children: [
            // Top area with header and search
            _buildHeader(),

            // Surah list content
            Expanded(child: _buildBody()),

            // Mini player pinned at bottom
            const MiniPlayerBar(),
          ],
        ),
      );
    }

    Widget _buildHeader() {
      return Container(
        color: AppTheme.backgroundDark,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App title
                Row(
                  children: [
                    const Text(
                      'بِسْمِ اللَّهِ',
                      style: TextStyle(
                        color: AppTheme.accentGold,
                        fontSize: 18,
                        fontFamily: 'serif',
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.headphones_rounded,
                              color: AppTheme.accentGold, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Audio',
                            style: TextStyle(
                                color: AppTheme.accentGold, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Quran Player',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),

                // Search field
                TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    context.read<SurahBloc>().add(SurahSearchChanged(query));
                  },
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search Surah by name or number...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              context
                                  .read<SurahBloc>()
                                  .add(const SurahSearchCleared());
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildBody() {
      return BlocBuilder<SurahBloc, SurahState>(
        builder: (context, state) {
          if (state is SurahLoading) {
            return const ShimmerList();
          }

          if (state is SurahError) {
            return _buildError(state.message);
          }

          if (state is SurahLoaded) {
            return _buildList(state);
          }

          return const SizedBox.shrink();
        },
      );
    }

    Widget _buildList(SurahLoaded state) {
      if (state.displayedSurahs.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off_rounded,
                  color: AppTheme.textMuted, size: 48),
              const SizedBox(height: 12),
              Text(
                'No Surahs found for "${state.searchQuery}"',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
            ],
          ),
        );
      }

      return BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, playerState) {
          final playingSurahNumber =
              playerState is PlayerActive ? playerState.surah.number : -1;

          return Column(
            children: [
              // Results count
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Row(
                  children: [
                    Text(
                      state.isSearching
                          ? '${state.displayedSurahs.length} results'
                          : '${state.allSurahs.length} Surahs',
                      style: const TextStyle(
                          color: AppTheme.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.displayedSurahs.length,
                  padding: const EdgeInsets.only(bottom: 8),
                  itemBuilder: (context, index) {
                    final surah = state.displayedSurahs[index];
                    return SurahListTile(
                      surah: surah,
                      isPlaying: surah.number == playingSurahNumber,
                      onTap: () => _onSurahTapped(surah),
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
    }

    Widget _buildError(String message) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  color: AppTheme.error, size: 56),
              const SizedBox(height: 16),
              const Text(
                'Connection Error',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<SurahBloc>().add(const SurahLoadRequested());
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGold,
                  foregroundColor: AppTheme.backgroundDark,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }