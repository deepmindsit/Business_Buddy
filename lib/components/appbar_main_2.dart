import 'package:businessbuddy/components/search_location.dart';

import '../utils/exported_path.dart';

class CustomMainHeader2 extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final TextEditingController searchController;

  CustomMainHeader2({
    super.key,
    this.showBackButton = true,
    this.onBackTap,
    required this.searchController,
  });

  final controller = getIt<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 8.w).copyWith(top: 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor.withValues(alpha: 0.5), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Location Label
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        SafeArea(
                          child: DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.8,
                            minChildSize: 0.4,
                            maxChildSize: 1.0,
                            builder: (_, controllerScroll) {
                              return Container(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(
                                    context,
                                  ).viewInsets.bottom,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.r),
                                    topRight: Radius.circular(20.r),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  controller: controllerScroll,
                                  child: SearchLocation(),
                                ),
                              );
                            },
                          ),
                        ),
                        enableDrag: true, // Allow dragging to close
                        isDismissible: true, // Allow tapping outside to close
                      );
                    },
                    child: SizedBox(
                      width: Get.width * 0.8.w,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.location_on,
                            color: Colors.black,
                            size: 14.sp,
                          ),
                          Flexible(
                            child: CustomText(
                              title: getIt<SearchNewController>().address.value,
                              fontSize: 13.sp,
                              color: Colors.black,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                            size: 14.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),

                /// 🔹 Top Row: Logo + Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Image.asset(Images.appIcon, width: Get.width * 0.07.w),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GestureDetector(
                          onTap: () => Get.toNamed(Routes.globalSearch),
                          child: SizedBox(
                            height: 35.h,
                            child: TextFormField(
                              onTap: () => Get.toNamed(Routes.globalSearch),
                              controller: searchController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: buildOutlineInputBorder(),
                                enabledBorder: buildOutlineInputBorder(),
                                // 👇 MAKE FIELD SMALL HEIGHT
                                contentPadding: EdgeInsets.all(
                                  15,
                                  // vertical: 12,
                                  // horizontal: 12,
                                ),
                                isDense: true,
                                visualDensity: VisualDensity(
                                  horizontal: -2,
                                  vertical: -2,
                                ),
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  maxWidth: Get.width * 0.1,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image.asset(
                                    Images.appIcon,
                                    width: 18,
                                    height: 18,
                                  ),
                                ),

                                hintText: 'Search Offer, Interest, etc.',
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildActionIcon(
                      color: primaryColor.withValues(alpha: 0.7),
                      icon: HugeIcons.strokeRoundedNotification02,
                      onTap: () => Get.toNamed(Routes.notificationList),
                    ),
                    _buildActionIcon(
                      color: primaryColor,
                      icon: HugeIcons.strokeRoundedUserStory,
                      onTap: () {
                        if (!getIt<DemoService>().isDemo) {
                          ToastUtils.showLoginToast();
                          return;
                        }
                        Get.toNamed(
                          Routes.profile,
                          arguments: {'user_id': 'self'},
                        );
                      },
                    ),
                  ],
                ),

                // SizedBox(height: 8.h),

                // /// 🔹 Search Field
                // Row(
                //   children: [
                //     Expanded(
                //       child: buildTextField(
                //         controller: searchController,
                //         hintText: 'Search Offer, Interest, etc.',
                //         prefixIcon: Icon(Icons.search, color: lightGrey),
                //         validator: (value) => value!.trim().isEmpty
                //             ? 'Search Offer, Interest, etc.'
                //             : null,
                //       ),
                //     ),
                //     _buildActionIcon(
                //       color: primaryColor,
                //       iconColor: Colors.white,
                //       icon: HugeIcons.strokeRoundedFilter,
                //       onTap: () {},
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
        CustomTabBar(),
      ],
    );
  }

  /// 🔹 Common Action Icon Builder
  Widget _buildActionIcon({
    required var icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 8.w),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          // color: color ?? lightGrey,
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: HugeIcon(icon: icon, color: primaryColor, size: 18.sp),
      ),
    );
  }
}
