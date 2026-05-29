// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/surah_bloc.dart';
import 'blocs/player_bloc.dart';
import 'repositories/quran_repository.dart';
import 'screens/surah_list_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => QuranRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SurahBloc(
              repository: context.read<QuranRepository>(),
            )..add(const SurahLoadRequested()),
          ),
          BlocProvider(
            create: (context) => PlayerBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'Qurantom',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: const SurahListScreen(),
        ),
      ),
    );
  }
}