import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/action_model.dart';

class GeminiService {
  final String apiKey;
  late final GenerativeModel _model;
  final List<Content> _history = [];

  GeminiService(this.apiKey) {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system('''
You are an Android System Agent. Your goal is to control the device based on user voice commands.
You MUST respond ONLY with a valid JSON object. Do not include markdown formatting or extra text.

You can perform multiple actions in sequence to achieve a goal.
JSON Schema:
{
  "response": "What you will say back to the user",
  "actions": [
    {
      "type": "shell" | "tap" | "input" | "scroll" | "screenshot" | "local_command" | "wait" | "response_only",
      "command": "shell command if type is shell",
      "payload": {
        "target": "text or resource-id for tap/input",
        "text": "text to type",
        "direction": "up/down/left/right"
      }
    }
  ]
}

Available Local Commands: "toggle_wifi", "volume_up", "volume_down", "brightness_up", "brightness_down", "toggle_dnd".

Context Awareness:
You will be provided with the current screen content (UI Tree). Use it to find targets for tap/input.
If the user asks about something on the screen, analyze the provided UI Tree.

Examples:
- "Send message to Dad on WhatsApp": {
    "response": "Sending message to Dad.",
    "actions": [
      {"type": "shell", "command": "am start -n com.whatsapp/.Main"},
      {"type": "wait"},
      {"type": "tap", "payload": {"target": "Dad"}},
      {"type": "input", "payload": {"target": "Type a message", "text": "Hello Dad"}},
      {"type": "tap", "payload": {"target": "Send"}}
    ]
  }
'''),
    );
  }

  Stream<ActionResponse> streamAction(String prompt, {String? screenContext}) async* {
    final fullPrompt = screenContext != null 
        ? "Current Screen Content:\n$screenContext\n\nUser Request: $prompt"
        : prompt;

    _history.add(Content.text(fullPrompt));
    
    final responseStream = _model.generateContentStream([
      ..._history,
      Content.text(fullPrompt),
    ]);

    String fullResponse = "";
    await for (final chunk in responseStream) {
      fullResponse += chunk.text ?? "";
    }

    final cleaned = fullResponse.replaceAll('```json', '').replaceAll('```', '').trim();
    
    try {
      final json = jsonDecode(cleaned);
      final actionResponse = ActionResponse.fromJson(json);
      _history.add(Content.model([TextPart(fullResponse)]));
      
      if (_history.length > 20) _history.removeRange(0, 2);
      
      yield actionResponse;
    } catch (e) {
      yield ActionResponse(
        success: false,
        message: "I'm sorry, I couldn't parse that command correctly.",
        actions: [ActionModel(type: ActionType.responseOnly, command: "")],
      );
    }
  }
}