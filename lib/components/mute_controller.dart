import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class GlobalVideoMuteController extends GetxController {
  final isMuted = false.obs; // default muted like Instagram

  void toggleMute() {
    isMuted.toggle();
  }

  void mute() => isMuted.value = true;
  void unmute() => isMuted.value = false;
}
