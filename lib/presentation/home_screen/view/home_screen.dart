import 'package:businessbuddy/utils/exported_path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = getIt<NavigationController>();

  final List<Widget> topTabPages = const [Explorer(), NewFeed(), LboScreen()];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // If CatList or any subpage is open
      if (controller.isSubPageOpen.value) {
        return controller.homeContent;
      }

      // Otherwise show normal home with tabs
      return topTabPages[controller.topTabIndex.value];
    });
  }
}
