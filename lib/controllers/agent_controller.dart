import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AgentState { listening, thinking, speaking, idle }

class AgentController extends ChangeNotifier {
  AgentState state = AgentState.idle;
  double soundLevel = 0.0;
  String currentTranscript = "";
  String language = "ar";

  void toggleActivation() {
    notifyListeners();
  }

  void switchLanguage(String lang) {
    language = lang;
    notifyListeners();
  }

  void triggerHaptic() {
    HapticFeedback.lightImpact();
  }
  
  Future<void> startListening() async {
    notifyListeners();
  }
}
