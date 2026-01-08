import 'package:businessbuddy/utils/exported_path.dart';

class NewFeed extends StatefulWidget {
  const NewFeed({super.key});

  @override
  State<NewFeed> createState() => _NewFeedState();
}

class _NewFeedState extends State<NewFeed> {
  final controller = getIt<FeedsController>();

  @override
  void initState() {
    super.initState();
    getIt<SpecialOfferController>().resetData();
    controller.getFeeds(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// 🔹 Initial Loading (Shimmer)
      if (controller.isLoading.isTrue) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          itemCount: 5,
          itemBuilder: (_, i) => const FeedShimmer(),
        );
      }

      /// 🔹 Empty State
      if (controller.feedList.isEmpty) {
        return commonNoDataFound(isHome: true);
      }

      /// 🔹 Feeds + Pagination
      return NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll is ScrollEndNotification &&
              scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
              controller.hasMore &&
              !controller.isLoadMore.value &&
              !controller.isLoading.value) {
            controller.getFeeds(showLoading: false);
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// 🔹 Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: 'Feeds',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    _buildFilterButton(),
                  ],
                ),
              ),

              /// 🔹 Feed List
              Obx(
                () => AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    itemCount: controller.feedList.length,
                    itemBuilder: (_, i) {
                      final item = controller.feedList[i];

                      return AnimationConfiguration.staggeredList(
                        position: i,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50,
                          child: FadeInAnimation(
                            child: item['type'] == 'offer'
                                ? OfferCard(
                                    data: item,
                                    onLike: () => handleOfferLike(
                                      item,
                                      () async => await controller.getFeeds(
                                        showLoading: false,
                                        isRefresh: false,
                                      ),
                                    ),
                                  )
                                : FeedCard(
                                    key: ValueKey(item['post_id'].toString()),
                                    data: item,
                                    onLike: () => handleFeedLike(
                                      item,
                                      () async => await controller.getFeeds(
                                        showLoading: false,
                                        isRefresh: false,
                                      ),
                                    ),
                                    onFollow: () async {
                                      if (controller
                                          .isFollowProcessing
                                          .isTrue) {
                                        return;
                                      }
                                      controller.isFollowProcessing.value =
                                          true;
                                      try {
                                        final businessId = item['business_id']
                                            .toString();
                                        if (item['is_followed'] == true) {
                                          await controller.unfollowBusiness(
                                            item['follow_id'].toString(),
                                          );
                                        } else {
                                          await controller.followBusiness(
                                            businessId,
                                          );
                                        }

                                        item['is_followed'] =
                                            !item['is_followed'];

                                        controller.feedList.refresh();
                                        await controller.getFeeds(
                                          showLoading: false,
                                        );
                                      } finally {
                                        controller.isFollowProcessing.value =
                                            false;
                                      }
                                    },
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
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
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Obx(
  //     () => controller.isLoading.isTrue
  //         ? ListView.builder(
  //             padding: EdgeInsets.symmetric(horizontal: 8.w),
  //             itemCount: 5,
  //             itemBuilder: (_, i) => const FeedShimmer(),
  //           )
  //         : controller.feedList.isEmpty
  //         ? commonNoDataFound(isHome: true)
  //         : SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 16.w),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       CustomText(
  //                         title: 'Feeds',
  //                         fontSize: 18.sp,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                       _buildFilterButton(),
  //                     ],
  //                   ),
  //                 ),
  //                 AnimationLimiter(
  //                   child: ListView.builder(
  //                     shrinkWrap: true,
  //                     physics: NeverScrollableScrollPhysics(),
  //                     padding: EdgeInsets.symmetric(horizontal: 8.w),
  //                     itemCount: controller.feedList.length,
  //                     itemBuilder: (_, i) {
  //                       final item = controller.feedList[i];
  //                       return AnimationConfiguration.staggeredList(
  //                         position: i,
  //                         duration: const Duration(milliseconds: 375),
  //                         child: SlideAnimation(
  //                           verticalOffset: 50,
  //                           child: FadeInAnimation(
  //                             child: item['type'] == 'offer'
  //                                 ? OfferCard(
  //                                     data: item,
  //                                     onLike: () => handleOfferLike(
  //                                       item,
  //                                       () async => await controller.getFeeds(
  //                                         showLoading: false,
  //                                       ),
  //                                     ),
  //                                   )
  //                                 : FeedCard(
  //                                     onLike: () => handleFeedLike(
  //                                       item,
  //                                       () => controller.getFeeds(
  //                                         showLoading: false,
  //                                       ),
  //                                     ),
  //
  //                                     // () async {
  //                                     //   if (controller
  //                                     //       .isLikeProcessing
  //                                     //       .isTrue) {
  //                                     //     return; // <<< stops multiple taps
  //                                     //   }
  //                                     //   controller.isLikeProcessing.value =
  //                                     //       true;
  //                                     //
  //                                     //   if (!getIt<DemoService>().isDemo) {
  //                                     //     ToastUtils.showLoginToast();
  //                                     //     controller.isLikeProcessing.value =
  //                                     //         false;
  //                                     //     return;
  //                                     //   }
  //                                     //   try {
  //                                     //     bool wasLiked = item['is_liked'];
  //                                     //     int likeCount =
  //                                     //         int.tryParse(
  //                                     //           item['likes_count'].toString(),
  //                                     //         ) ??
  //                                     //         0;
  //                                     //
  //                                     //     if (wasLiked) {
  //                                     //       await controller.unLikeBusiness(
  //                                     //         item['liked_id'].toString(),
  //                                     //       );
  //                                     //       item['likes_count'] =
  //                                     //           (likeCount - 1).clamp(
  //                                     //             0,
  //                                     //             999999,
  //                                     //           );
  //                                     //     } else {
  //                                     //       await controller.likeBusiness(
  //                                     //         item['business_id'].toString(),
  //                                     //         item['post_id'].toString(),
  //                                     //       );
  //                                     //       item['likes_count'] = likeCount + 1;
  //                                     //     }
  //                                     //
  //                                     //     // Toggle locally
  //                                     //     item['is_liked'] = !wasLiked;
  //                                     //     await controller.getFeeds(
  //                                     //       showLoading: false,
  //                                     //     );
  //                                     //   } finally {
  //                                     //     controller.isLikeProcessing.value =
  //                                     //         false;
  //                                     //   }
  //                                     // },
  //                                     data: item,
  //                                     onFollow: () async {
  //                                       if (controller
  //                                           .isFollowProcessing
  //                                           .isTrue) {
  //                                         return; // <<< stops multiple taps
  //                                       }
  //                                       controller.isFollowProcessing.value =
  //                                           true;
  //                                       if (getIt<DemoService>().isDemo ==
  //                                           false) {
  //                                         ToastUtils.showLoginToast();
  //                                         controller.isFollowProcessing.value =
  //                                             false;
  //                                         return;
  //                                       }
  //                                       try {
  //                                         if (item['is_followed'] == true) {
  //                                           await controller.unfollowBusiness(
  //                                             item['follow_id'].toString(),
  //                                           );
  //                                         } else {
  //                                           await controller.followBusiness(
  //                                             item['business_id'].toString(),
  //                                           );
  //                                         }
  //
  //                                         item['is_followed'] =
  //                                             !item['is_followed'];
  //
  //                                         await controller.getFeeds(
  //                                           showLoading: false,
  //                                         );
  //                                       } finally {
  //                                         controller.isFollowProcessing.value =
  //                                             false;
  //                                       }
  //                                     },
  //                                   ),
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //   );
  // }

  // Enhanced Filter Button Widget
  Widget _buildFilterButton() {
    return Obx(
      () => Container(
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: getIt<SpecialOfferController>().isApply.isTrue
              ? primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
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
      const FeedSheet(isFrom: 'feed'),
    );
  }
}
