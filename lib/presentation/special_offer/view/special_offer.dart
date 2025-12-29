import 'package:businessbuddy/utils/exported_path.dart';

class SpecialOffer extends StatefulWidget {
  const SpecialOffer({super.key});

  @override
  State<SpecialOffer> createState() => _SpecialOfferState();
}

class _SpecialOfferState extends State<SpecialOffer> {
  final controller = getIt<SpecialOfferController>();
  // final _homeController = getIt<HomeController>();
  // final _feedController = getIt<FeedsController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.resetData();
      controller.getSpecialOffer(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        /// 🔹 Initial Loading (Shimmer)
        if (controller.isLoading.isTrue) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            itemCount: 5,
            itemBuilder: (_, i) => const FeedShimmer(),
          );
        }

        /// 🔹 Empty State
        if (controller.offerList.isEmpty) {
          return commonNoDataFound();
        }

        /// 🔹 Feeds + Pagination
        return NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll is ScrollEndNotification &&
                scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
                controller.hasMore &&
                !controller.isLoadMore.value &&
                !controller.isLoading.value) {
              controller.getSpecialOffer(showLoading: false);
            }
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: 'Special Offers',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      _buildFilterButton(),
                    ],
                  ),
                ),

                /// 🔹 Feed List
                AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    itemCount: controller.offerList.length,
                    itemBuilder: (_, i) {
                      final item = controller.offerList[i];
                      return AnimationConfiguration.staggeredList(
                        position: i,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: OfferCard(
                              data: item,
                              onLike: () => handleOfferLike(
                                item,
                                () async => await controller.getSpecialOffer(
                                  showLoading: false,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// 🔹 Pagination Loader
                Obx(
                  () => controller.isLoadMore.value
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: LoadingWidget(color: primaryColor),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        );
      }),

      // Obx(
      //   () => controller.isLoading.isTrue
      //       ? ListView.builder(
      //           padding: EdgeInsets.symmetric(horizontal: 8.w),
      //           itemCount: 5,
      //           itemBuilder: (_, i) => const FeedShimmer(),
      //         )
      //       : controller.offerList.isEmpty
      //       ? commonNoDataFound()
      //       : SingleChildScrollView(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.end,
      //             mainAxisAlignment: MainAxisAlignment.end,
      //             children: [
      //               Padding(
      //                 padding: EdgeInsets.symmetric(horizontal: 16.w),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     CustomText(
      //                       title: 'Special Offers',
      //                       fontSize: 18.sp,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                     _buildFilterButton(),
      //                   ],
      //                 ),
      //               ),
      //               AnimationLimiter(
      //                 child: ListView.builder(
      //                   shrinkWrap: true,
      //                   physics: NeverScrollableScrollPhysics(),
      //                   padding: EdgeInsets.symmetric(horizontal: 8.w),
      //                   itemCount: controller.offerList.length,
      //                   itemBuilder: (_, i) {
      //                     final item = controller.offerList[i];
      //                     return AnimationConfiguration.staggeredList(
      //                       position: i,
      //                       duration: const Duration(milliseconds: 375),
      //                       child: SlideAnimation(
      //                         verticalOffset: 50.0,
      //                         child: FadeInAnimation(
      //                           child: OfferCard(
      //                             data: item,
      //                             onLike: () => handleOfferLike(
      //                               item,
      //                               () async => await controller
      //                                   .getSpecialOffer(showLoading: false),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      // ),
    );
  }

  // Enhanced Filter Button Widget
  Widget _buildFilterButton() {
    return Container(
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: primaryColor.withValues(alpha: 0.1),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showFilterBottomSheet(),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedFilter,
                  size: 16.r,
                  color: primaryColor,
                ),
                SizedBox(width: 2.w),
                CustomText(
                  title: 'Filter',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Filter Bottom Sheet Method
  void _showFilterBottomSheet() {
    Get.bottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.grey.withValues(alpha: 0.05),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      const FeedSheet(isFrom: 'offer'),
    );
  }

  // bool _isUserAuthenticated() {
  //   return getIt<DemoService>().isDemo;
  // }
  //
  // Future<void> _handleOfferLike(Map<String, dynamic> item) async {
  //   if (_feedController.isLikeProcessing.value) return;
  //
  //   if (!_isUserAuthenticated()) {
  //     ToastUtils.showLoginToast();
  //     return;
  //   }
  //
  //   await _feedController.isLikeProcessing.runWithLoader(() async {
  //     await toggleOfferLike(
  //       item,
  //       () => controller.getSpecialOffer(showLoading: false),
  //     );
  //   });
  // }
}
