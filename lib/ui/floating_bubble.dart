import 'package:dash_bubble/dash_bubble.dart';

class FloatingBubble {
  static Future<void> show() async {
    final hasPermission = await DashBubble.instance.requestOverlayPermission();
    if (hasPermission) {
      await DashBubble.instance.startBubble(
        onTap: () {},
      );
    }
  }
}