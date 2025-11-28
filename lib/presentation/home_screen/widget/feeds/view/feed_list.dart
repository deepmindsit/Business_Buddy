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
    controller.getFeeds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.isTrue
          // ? LoadingWidget(color: primaryColor)
          ? ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemCount: 5, // shimmer count
              itemBuilder: (_, i) => const FeedShimmer(),
            )
          : controller.feedList.isEmpty
          ? Center(
              child: CustomText(
                title: 'No Data Found',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    itemCount: controller.feedList.length,
                    itemBuilder: (_, i) {
                      final item = controller.feedList[i];

                      return item['type'] == 'offer'
                          ? OfferCard(data: item)
                          : FeedCard(
                              onLike: () async {
                                if (controller.isLikeProcessing.isTrue) {
                                  return; // <<< stops multiple taps
                                }
                                controller.isLikeProcessing.value = true;

                                if (!getIt<DemoService>().isDemo) {
                                  ToastUtils.showLoginToast();
                                  controller.isLikeProcessing.value = false;
                                  return;
                                }
                                try {
                                  bool wasLiked = item['is_liked'];
                                  int likeCount =
                                      int.tryParse(
                                        item['likes_count'].toString(),
                                      ) ??
                                      0;

                                  if (wasLiked) {
                                    await controller.unLikeBusiness(
                                      item['liked_id'].toString(),
                                    );
                                    item['likes_count'] = (likeCount - 1).clamp(
                                      0,
                                      999999,
                                    );
                                  } else {
                                    await controller.likeBusiness(
                                      item['business_id'].toString(),
                                      item['post_id'].toString(),
                                    );
                                    item['likes_count'] = likeCount + 1;
                                  }

                                  // Toggle locally
                                  item['is_liked'] = !wasLiked;
                                  await controller.getFeeds(showLoading: false);
                                } catch (e) {
                                  print("follow error: $e");
                                } finally {
                                  controller.isLikeProcessing.value = false;
                                }
                              },
                              data: item,
                              onFollow: () async {
                                if (controller.isFollowProcessing.isTrue) {
                                  return; // <<< stops multiple taps
                                }
                                controller.isFollowProcessing.value = true;
                                if (getIt<DemoService>().isDemo == false) {
                                  ToastUtils.showLoginToast();
                                  controller.isFollowProcessing.value = false;
                                  return;
                                }
                                try {
                                  if (item['is_followed'] == true) {
                                    await controller.unfollowBusiness(
                                      item['follow_id'].toString(),
                                    );
                                  } else {
                                    await controller.followBusiness(
                                      item['business_id'].toString(),
                                    );
                                  }

                                  item['is_followed'] = !item['is_followed'];

                                  await controller.getFeeds(showLoading: false);
                                } catch (e) {
                                  print("follow error: $e");
                                } finally {
                                  controller.isFollowProcessing.value = false;
                                }
                              },
                            );
                    },
                  ),
                ],
              ),
            ),
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
          onTap: () => _showFilterBottomSheet(context),
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
  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.grey.withValues(alpha: 0.05),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // context: context,
      const FeedSheet(),
    );
  }
}
