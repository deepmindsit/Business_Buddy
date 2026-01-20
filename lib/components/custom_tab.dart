import '../utils/exported_path.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  final controller = getIt<NavigationController>();
  final List<Map<String, dynamic>> tabs = [
    {'icon': HugeIcons.strokeRoundedBriefcase08, 'label': 'Explorer'},
    {'icon': HugeIcons.strokeRoundedMenuSquare, 'label': 'Feeds'},
    {'icon': HugeIcons.strokeRoundedUser03, 'label': 'My Business'},
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: Get.width,
        height: 35.h,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.symmetric(horizontal: BorderSide(color: primaryColor)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(tabs.length, (index) {
            final isSelected =
                controller.topTabIndex.value == index &&
                controller.isTopTabSelected.value;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.updateTopTab(index),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor
                        : Theme.of(context).scaffoldBackgroundColor,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HugeIcon(
                        icon: tabs[index]['icon'],
                        color: isSelected ? Colors.white : textSmall,
                        size: 18.sp,
                      ),
                      SizedBox(width: 6.w),
                      Flexible(
                        child: Text(
                          tabs[index]['label'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected ? Colors.white : textSmall,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
