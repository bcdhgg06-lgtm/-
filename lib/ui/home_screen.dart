import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/agent_controller.dart';
import 'permission_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("AI System Agent"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<AgentController>(
              builder: (context, controller, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getStateColor(controller.state).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStateColor(controller.state)),
                  ),
                  child: Text(
                    controller.state.name.toUpperCase(),
                    style: TextStyle(color: _getStateColor(controller.state), fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            const Text(
              "Voice Assistant Active",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => PermissionScreen()));
              },
              child: const Text("Manage Permissions"),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStateColor(AgentState state) {
    switch (state) {
      case AgentState.idle: return Colors.grey;
      case AgentState.listening: return Colors.redAccent;
      case AgentState.thinking: return Colors.blueAccent;
      case AgentState.speaking: return Colors.greenAccent;
    }
  }
}