import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

class VoiceService {
  final SpeechToText _stt = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  
  final _transcriptController = StreamController<String>.broadcast();
  Stream<String> get transcriptStream => _transcriptController.stream;

  final _soundLevelController = StreamController<double>.broadcast();
  Stream<double> get soundLevelStream => _soundLevelController.stream;

  String _language = "en-US";
  String get language => _language;

  Future<void> setLanguage(String langCode) async {
    _language = langCode;
    await _tts.setLanguage(langCode);
    // Note: STT language is set during startListening
  }

  Future<void> startListening() async {
    await _stt.listen(
      onResult: (result) {
        _transcriptController.add(result.recognizedWords);
      },
      onSoundLevelChange: (level) {
        _soundLevelController.add(level);
      },
      localeId: _language,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      listenOptions: SpeechListenOptions(partialResults: true),
    );
  }

  Future<void> stopListening() async {
    await _stt.stop();
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }
}