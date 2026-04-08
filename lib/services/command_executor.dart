import 'package:flutter/services.dart';
import '../models/action_model.dart';
import 'dart:developer' as developer;

class CommandExecutor {
  static const _shizukuChannel = MethodChannel('com.example.ai_agent/shizuku');
  static const _accessibilityChannel = MethodChannel('com.example.ai_agent/accessibility');

  Future<void> executeResponse(ActionResponse response) async {
    for (final action in response.actions) {
      await execute(action);
    }
  }

  Future<bool> execute(ActionModel action) async {
    try {
      switch (action.type) {
        case ActionType.shell:
          await _shizukuChannel.invokeMethod('executeShell', {'command': action.command});
          return true;
        
        case ActionType.screenshot:
          await _shizukuChannel.invokeMethod('executeShell', {'command': 'screencap -p /sdcard/Download/screenshot.png'});
          return true;

        case ActionType.tap:
          await _accessibilityChannel.invokeMethod('tapNode', {'target': action.target});
          return true;

        case ActionType.input:
          await _accessibilityChannel.invokeMethod('inputText', {
            'target': action.target,
            'text': action.text
          });
          return true;

        case ActionType.scroll:
          await _accessibilityChannel.invokeMethod('scroll', {'direction': action.direction});
          return true;

        case ActionType.localCommand:
          await _handleLocalCommand(action.command);
          return true;

        case ActionType.wait:
          await Future.delayed(const Duration(milliseconds: 1500));
          return true;

        case ActionType.responseOnly:
          return true;
        
        case ActionType.command:
        case ActionType.search:
        case ActionType.apps:
        case ActionType.settings:
          // Existing types if they are still needed or handled differently
          return true;
      }
    } catch (e) {
      developer.log("Execution Error: $e");
      return false;
    }
  }

  Future<void> _handleLocalCommand(String? command) async {
    if (command == null) return;
    switch (command) {
      case "volume_up":
        await _shizukuChannel.invokeMethod('executeShell', {'command': 'input keyevent 24'});
        break;
      case "volume_down":
        await _shizukuChannel.invokeMethod('executeShell', {'command': 'input keyevent 25'});
        break;
      case "brightness_up":
        await _shizukuChannel.invokeMethod('executeShell', {'command': 'input keyevent 221'});
        break;
      case "brightness_down":
        await _shizukuChannel.invokeMethod('executeShell', {'command': 'input keyevent 220'});
        break;
      case "toggle_wifi":
        await _shizukuChannel.invokeMethod('executeShell', {'command': 'svc wifi enable'});
        await _shizukuChannel.invokeMethod('executeShell', {'command': 'svc wifi disable'});
        break;
       case "open_camera":
        await _shizukuChannel.invokeMethod('executeShell', {'command': 'am start -a android.media.action.IMAGE_CAPTURE'});
        break;
      case "toggle_dnd":
        await _shizukuChannel.invokeMethod('executeShell', {'command': 'cmd notification set_interruption_filter 1'});
        await _shizukuChannel.invokeMethod('executeShell', {'command': 'cmd notification set_interruption_filter 3'});
        break;

    }
  }

  Future<String> getScreenContent() async {
    try {
      return await _accessibilityChannel.invokeMethod('getScreenContent');
    } catch (e) {
      return "Error getting screen content: $e";
    }
  }
}