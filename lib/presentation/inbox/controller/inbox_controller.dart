import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class InboxController extends GetxController {
  final controller = TextEditingController();
  final messages = [
    {'text': 'Hi there! 👋', 'isMe': false},
    {'text': 'Hey! How are you?', 'isMe': true},
    {'text': 'I’m good, just working on a new Flutter project 😄', 'isMe': false},
    {'text': 'Nice! Flutter makes UI so easy to build.', 'isMe': true},
    {'text': 'Totally agree with you! 🚀', 'isMe': false},
  ].obs;
}
