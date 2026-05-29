// repositories/quran_repository.dart
// Handles all API communication with alquran.cloud

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';

/// Repository that communicates with the AlQuran Cloud API.
/// API Documentation: https://alquran.cloud/api
class QuranRepository {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';
  final http.Client _client;

  QuranRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches all 114 Surahs from the Quran API.
  /// Returns a list of [Surah] objects.
  /// Throws [Exception] on network or parsing errors.
  Future<List<Surah>> fetchAllSurahs() async {
    final uri = Uri.parse('$_baseUrl/surah');

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;

        if (body['code'] == 200 && body['status'] == 'OK') {
          final data = body['data'] as List<dynamic>;
          return data
              .map((json) => Surah.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('API returned error: ${body['status']}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Surahs: $e');
    }
  }

  /// Searches surahs by [query] matching english name or translation.
  /// This is done client-side after fetching all surahs.
  Future<List<Surah>> searchSurahs(String query) async {
    final all = await fetchAllSurahs();
    if (query.trim().isEmpty) return all;

    final lowerQuery = query.toLowerCase();
    return all.where((surah) {
      return surah.englishName.toLowerCase().contains(lowerQuery) ||
          surah.englishNameTranslation.toLowerCase().contains(lowerQuery) ||
          surah.name.contains(query) ||
          surah.number.toString() == query.trim();
    }).toList();
  }

  void dispose() {
    _client.close();
  }
}