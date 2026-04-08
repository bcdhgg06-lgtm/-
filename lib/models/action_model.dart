enum ActionType {
  command,
  search,
  apps,
  settings,
  shell,
  screenshot,
  tap,
  input,
  scroll,
  localCommand,
  wait,
  responseOnly
}

class ActionModel {
  final ActionType type;
  final String command;
  final String? payload;
  final String? target;
  final String? text;
  final String? direction;

  ActionModel({
    required this.type,
    required this.command,
    this.payload,
    this.target,
    this.text,
    this.direction,
  });

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    ActionType type;
    final typeString = json['type'] as String?;
    
    switch (typeString) {
      case 'command': type = ActionType.command; break;
      case 'search': type = ActionType.search; break;
      case 'apps': type = ActionType.apps; break;
      case 'settings': type = ActionType.settings; break;
      case 'shell': type = ActionType.shell; break;
      case 'screenshot': type = ActionType.screenshot; break;
      case 'tap': type = ActionType.tap; break;
      case 'input': type = ActionType.input; break;
      case 'scroll': type = ActionType.scroll; break;
      case 'local_command': 
      case 'localCommand': type = ActionType.localCommand; break;
      case 'wait': type = ActionType.wait; break;
      case 'response_only':
      case 'responseOnly': type = ActionType.responseOnly; break;
      default: type = ActionType.command;
    }

    return ActionModel(
      type: type,
      command: json['command'] ?? '',
      payload: json['payload'],
      target: json['target'],
      text: json['text'],
      direction: json['direction'],
    );
  }
}

class ActionResponse {
  final bool success;
  final String message;
  final List<ActionModel> actions;

  ActionResponse({
    required this.success,
    required this.message,
    required this.actions,
  });

  factory ActionResponse.fromJson(Map<String, dynamic> json) {
    return ActionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      actions: (json['actions'] as List? ?? [])
          .map((i) => ActionModel.fromJson(i))
          .toList(),
    );
  }
}