import 'package:businessbuddy/presentation/home_screen/controller/home_gate_controller.dart';
import 'package:businessbuddy/utils/exported_path.dart';

class HomeGateScreen extends StatefulWidget {
  const HomeGateScreen({super.key});

  @override
  State<HomeGateScreen> createState() => _HomeGateScreenState();
}

class _HomeGateScreenState extends State<HomeGateScreen> {
  final controller = getIt<HomeGateController>();
  @override
  void initState() {
    // 🔥 START FLOW HERE
    controller.startFlow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isReady.value) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LoadingWidget(color: primaryColor),
                const SizedBox(height: 16),
                Text(
                  controller.statusMessage.value,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      }

      return const HomeScreen();
    });
  }
}
