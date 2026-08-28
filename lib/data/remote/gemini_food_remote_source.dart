import 'dart:convert';
import 'package:flavr/core/errors/app_exception.dart';
import 'package:flavr/data/remote/gemini_client.dart';
import 'package:flavr/domain/models/food_suggestion.dart';

class GeminiFoodRemoteSource {
  final GeminiClient _client;

  const GeminiFoodRemoteSource(this._client);

  /// Fetches food suggestions using [prompt] and parses the JSON response.
  ///
  /// Attempts a retry with a stricter instruction if the first parse fails.
  Future<List<FoodSuggestion>> fetchSuggestions(String prompt) async {
    String raw = await _client.generateContent(prompt);

    try {
      return _parseResponse(raw);
    } catch (_) {
      // Retry once with a stricter re-prompt
      const retryPrefix =
          'Return ONLY a raw JSON array with no other text. '
          'Previous response could not be parsed. ';
      raw = await _client.generateContent(retryPrefix + prompt);
      try {
        return _parseResponse(raw);
      } catch (e) {
        throw ParseException(raw);
      }
    }
  }

  List<FoodSuggestion> _parseResponse(String raw) {
    final jsonStr = _extractJson(raw);
    final dynamic decoded = jsonDecode(jsonStr);
    if (decoded is! List) {
      throw ParseException(raw);
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(FoodSuggestion.fromJson)
        .toList();
  }

  String _extractJson(String raw) {
    // Remove markdown code fences if present
    final fenceMatch =
        RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```').firstMatch(raw);
    if (fenceMatch != null) {
      return fenceMatch.group(1)!.trim();
    }

    // Find the outermost JSON array
    final arrayStart = raw.indexOf('[');
    final arrayEnd = raw.lastIndexOf(']');
    if (arrayStart >= 0 && arrayEnd > arrayStart) {
      return raw.substring(arrayStart, arrayEnd + 1).trim();
    }

    return raw.trim();
  }
}
