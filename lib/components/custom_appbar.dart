import 'package:businessbuddy/utils/exported_path.dart';

class CustomSliverAppBar extends StatelessWidget {
  final bool isCollapsed;
  const CustomSliverAppBar({super.key, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: Get.height * 0.2.h,
      pinned: true,
      toolbarHeight: isCollapsed ? 100.h : 0.h,
      elevation: isCollapsed ? 6 : 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      title: isCollapsed
          ? SafeArea(
              child: Column(children: [_buildSearchBar(), CustomTabBar()]),
            )
          : const SizedBox(),
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
              ).copyWith(top: 16.h),
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
                      () => Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: _openLocationSheet,
                                child: SizedBox(
                                  width: Get.width * 0.8.w,
                                  child: Column(
                                    // spacing: 8,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        spacing: 4.w,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.black,
                                            size: 14.sp,
                                          ),
                                          CustomText(
                                            title: 'Location',
                                            fontSize: 13.sp,
                                            color: Colors.black,
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: CustomText(
                                              title:
                                                  getIt<SearchNewController>()
                                                      .address
                                                      .value,
                                              fontSize: 13.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              maxLines: 1,
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black,
                                            size: 14.sp,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            _buildNotificationIcon(),
                            SizedBox(width: 5.w),
                            _buildProfileIcon(),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    /// 🔹 Top Row: Logo + Icons
                    _buildSearchBar(),
                  ],
                ),
              ),
            ),
            CustomTabBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 8.w).copyWith(top: 4.h),
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.globalSearch),
        child: SizedBox(
          // height: 35.h,
          child: TextFormField(
            onTap: () => Get.toNamed(Routes.globalSearch),
            // controller: searchController,
            enabled: false,

            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: buildOutlineInputBorder(),
              enabledBorder: buildOutlineInputBorder(),
              disabledBorder: buildOutlineInputBorder(),
              // 👇 MAKE FIELD SMALL HEIGHT
              contentPadding: EdgeInsets.all(
                15,
                // vertical: 12,
                // horizontal: 12,
              ),
              isDense: true,
              visualDensity: VisualDensity(horizontal: -2, vertical: -2),
              suffixIcon: Icon(Icons.search, color: Colors.grey),
              prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.1),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Image.asset(Images.appIcon, width: 18, height: 18),
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
    );
  }

  void _openLocationSheet() {
    Get.bottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      SafeArea(
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          builder: (_, controllerScroll) {
            return SearchLocation();
          },
        ),
      ),
      enableDrag: true,
      isDismissible: true,
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 0.2,
      ), // Replace with AppColors.primaryColor
      borderRadius: BorderRadius.circular(100.r),
    );
  }

  Widget _buildNotificationIcon() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.notificationList),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.grey.shade700,
              size: 18.sp,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileIcon() {
    return GestureDetector(
      onTap: () {
        if (!getIt<DemoService>().isDemo) {
          ToastUtils.showLoginToast();
          return;
        }
        Get.toNamed(Routes.profile, arguments: {'user_id': 'self'});
      },
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_outline, color: primaryColor, size: 18.sp),
        ),
      ),
    );
  }
}
