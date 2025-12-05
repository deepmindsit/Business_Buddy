import 'package:businessbuddy/utils/exported_path.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final controller = getIt<NavigationController>();
  final searchController = getIt<SearchNewController>();

  @override
  void initState() {
    super.initState();
    // location();
    searchController.getLiveLocation();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Column(
              children: [
                CustomMainHeader2(searchController: TextEditingController()),
                Expanded(child: Obx(() => controller.pageStack.last)),
                // Expanded(
                //   child: NavigationController
                //       .widgetOptions[controller.currentIndex.value],
                // ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              boxShadow: [
                if (theme.brightness == Brightness.light)
                  BoxShadow(
                    color: mainGrey.withValues(alpha: 0.07),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  )
                else
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: BottomNavigationBar(
                backgroundColor: mainGrey,
                selectedItemColor: Colors.red,
                showUnselectedLabels: true,
                unselectedItemColor: Colors.black,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                currentIndex: controller.currentIndex.value,
                onTap: controller.updateBottomIndex,
                items: [
                  _buildNavItem(
                    HugeIcons.strokeRoundedHome01,
                    'Home',
                    0,
                    controller.currentIndex.value == 0,
                  ),
                  _buildNavItem(
                    HugeIcons.strokeRoundedMessage02,
                    'Inbox',
                    1,
                    controller.currentIndex.value == 1,
                  ),
                  _buildNavItem(
                    HugeIcons.strokeRoundedUserMultiple02,
                    'Business Partner',
                    2,
                    controller.currentIndex.value == 2,
                  ),

                  _buildNavItem(
                    HugeIcons.strokeRoundedTag01,
                    'Special Offers',
                    3,
                    controller.currentIndex.value == 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    var icon,
    String label,
    int index,
    bool isSelected, {
    double? iconSize,
  }) {
    return BottomNavigationBarItem(
      backgroundColor: mainGrey,
      icon: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(4.0),
        child: HugeIcon(
          size: iconSize ?? Get.width * 0.06,
          icon: icon,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      label: label,
    );
  }
}
