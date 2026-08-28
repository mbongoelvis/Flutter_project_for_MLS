import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flavr/core/constants/gemini_constants.dart';
import 'package:flavr/core/errors/app_exception.dart';

class GeminiClient {
  late final GenerativeModel _model;

  GeminiClient() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _model = GenerativeModel(
      model: kGeminiModel,
      apiKey: apiKey,
      systemInstruction: Content('system', [TextPart(kSystemPrompt)]),
      generationConfig: GenerationConfig(
        temperature: 0.9,
        topP: 0.95,
        topK: 40,
        maxOutputTokens: 4096,
      ),
    );
  }

  /// Sends [prompt] to Gemini and returns the raw text response.
  ///
  /// Throws [ApiQuotaException] when the rate limit is exceeded,
  /// or [NetworkException] for any other failure.
  Future<String> generateContent(String prompt) async {
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;
      if (text == null || text.trim().isEmpty) {
        throw const NetworkException();
      }
      return text;
    } catch (e) {
      if (e is AppException) rethrow;
      final message = e.toString().toLowerCase();
      if (message.contains('quota') ||
          message.contains('429') ||
          message.contains('resource_exhausted') ||
          message.contains('rate_limit')) {
        throw const ApiQuotaException();
      }
      throw const NetworkException();
    }
  }
}
