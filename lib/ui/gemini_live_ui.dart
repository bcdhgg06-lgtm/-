import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modern_app/controllers/agent_controller.dart';

class GeminiLiveUI extends StatelessWidget {
  const GeminiLiveUI({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AgentController>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('State: ${controller.state.name}'),
          Text('Language: ${controller.language}'),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () => controller.startListening(),
          ),
        ],
      ),
    );
  }
}
