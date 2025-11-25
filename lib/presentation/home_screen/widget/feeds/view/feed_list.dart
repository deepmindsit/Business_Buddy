import 'package:businessbuddy/presentation/home_screen/widget/feeds/widget/feed_card_shimmer.dart';
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
          : ListView.builder(
              shrinkWrap: true,
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
                                int.tryParse(item['likes_count'].toString()) ??
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
    );
  }
}
