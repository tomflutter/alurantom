// models/surah.dart
// Model representing a Surah (chapter) from the Quran API

import 'package:equatable/equatable.dart';

/// Represents a single Surah from alquran.cloud API
class Surah extends Equatable {
  final int number;
  final String name;          // Arabic name
  final String englishName;   // English transliteration
  final String englishNameTranslation; // English meaning
  final int numberOfAyahs;
  final String revelationType; // Meccan or Medinan
  final String audioUrl;       // Full audio URL for recitation

  const Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
    required this.audioUrl,
  });

  /// Factory constructor from API JSON response
  factory Surah.fromJson(Map<String, dynamic> json) {
    final number = json['number'] as int;
    return Surah(
      number: number,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
      revelationType: json['revelationType'] as String,
      // Using Abdul Basit Murattal recitation (reciter ID 7)
      audioUrl: 'https://cdn.islamic.network/quran/audio-surah/128/ar.abdulbasitmurattal/$number.mp3',
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'englishName': englishName,
        'englishNameTranslation': englishNameTranslation,
        'numberOfAyahs': numberOfAyahs,
        'revelationType': revelationType,
      };

  @override
  List<Object?> get props => [
        number,
        name,
        englishName,
        englishNameTranslation,
        numberOfAyahs,
        revelationType,
        audioUrl,
      ];

  @override
  String toString() => 'Surah(number: $number, englishName: $englishName)';
}