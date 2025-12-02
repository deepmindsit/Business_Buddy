import 'package:businessbuddy/utils/exported_path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeController = getIt<HomeController>();
  final _feedController = getIt<FeedsController>();
  final _navigationController = getIt<NavigationController>();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _homeController.requestLocationPermission();
    _homeController.getHomeApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(child: _buildHomeContent()),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSlider(),
        _buildCategorySection(),
        _buildFeedsSection(),
        _buildRequirementsSection(),
      ],
    );
  }

  Widget _buildSlider() {
    return Obx(
      () => _homeController.isLoading.isTrue
          ? _buildSliderLoader()
          : CustomCarouselSlider(
              height: 0.2.h,
              margin: EdgeInsets.symmetric(horizontal: 8),
              radius: 16.r,
              imageList: _homeController.sliderList,
            ),
    );
  }

  Widget _buildCategorySection() {
    return SectionContainer(
      title: 'Categories',
      actionText: 'View More',
      onActionTap: _handleViewAllCategories,
      child: Obx(
        () => _homeController.isLoading.isTrue
            ? buildCategoryLoader()
            : GridView.builder(
                padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 0.h,
                  childAspectRatio: 0.7,
                ),
                itemCount: _homeController.categoryList.length,
                itemBuilder: (context, index) {
                  final category = _homeController.categoryList[index];
                  return GestureDetector(
                    onTap: () {
                      _navigationController.openSubPage(
                        CategoryList(
                          categoryId: category['id'].toString(),
                          categoryName: category['name'].toString(),
                        ),
                      );
                    },
                    child: CategoryCard(
                      image: category['image'].toString(),
                      name: category['name'].toString(),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildFeedsSection() {
    return SectionContainer(
      title: 'Feeds',
      actionText: 'View More',
      onActionTap: _handleViewAllFeeds,
      child: Obx(
        () => _homeController.isLoading.isTrue
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                itemCount: 5, // shimmer count
                itemBuilder: (_, i) => const FeedShimmer(),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                itemCount: _homeController.feedsList.length,
                itemBuilder: (context, index) {
                  final feedItem = _homeController.feedsList[index];
                  return _buildFeedItem(feedItem);
                },
              ),
      ),
    );
  }

  Widget _buildFeedItem(Map<String, dynamic> item) {
    if (item['type'] == 'offer') {
      return OfferCard(data: item);
    }

    return FeedCard(
      data: item,
      onLike: () => _handleFeedLike(item),
      onFollow: () => _handleFeedFollow(item),
    );
  }

  Widget _buildRequirementsSection() {
    return SectionContainer(
      title: 'Business Requirements',
      actionText: 'View More',
      onActionTap: _handleViewAllRequirements,
      child: Obx(
        () => _homeController.isLoading.isTrue
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(8),
                itemCount: 6,
                separatorBuilder: (_, __) => SizedBox(height: 10),
                itemBuilder: (context, index) => const BusinessCardShimmer(),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                separatorBuilder: (context, index) =>
                    Divider(height: 1.h, color: lightGrey),
                itemCount: _homeController.requirementList.length,
                itemBuilder: (context, index) {
                  final requirement = _homeController.requirementList[index];
                  return BusinessCard(data: requirement);
                },
              ),
      ),
    );
  }

  Widget _buildSliderLoader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: Get.height * 0.15.h,
      width: Get.width,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            aspectRatio: 1,
            autoPlay: true,
            enlargeCenterPage: true,
            pauseAutoPlayOnTouch: true,
          ),
          items: List.generate(6, (index) {
            return GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: Colors.grey[300], // Shimmer effect
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> _handleFeedLike(Map<String, dynamic> item) async {
    if (_feedController.isLikeProcessing.value) return;

    if (!_isUserAuthenticated()) {
      ToastUtils.showLoginToast();
      return;
    }

    await _feedController.isLikeProcessing.runWithLoader(() async {
      await _toggleFeedLike(item);
    });
  }

  Future<void> _toggleFeedLike(Map<String, dynamic> item) async {
    final bool wasLiked = item['is_liked'] ?? false;
    final int likeCount = int.tryParse(item['likes_count'].toString()) ?? 0;

    try {
      if (wasLiked) {
        await _feedController.unLikeBusiness(item['liked_id'].toString());
        item['likes_count'] = (likeCount - 1).clamp(0, 999999);
      } else {
        await _feedController.likeBusiness(
          item['business_id'].toString(),
          item['post_id'].toString(),
        );
        item['likes_count'] = likeCount + 1;
      }

      item['is_liked'] = !wasLiked;
    } catch (e) {
      _handleError('Like error: $e');
      // Consider showing an error toast to the user
    }
  }

  Future<void> _handleFeedFollow(Map<String, dynamic> item) async {
    if (_feedController.isFollowProcessing.value) return;

    if (!_isUserAuthenticated()) {
      ToastUtils.showLoginToast();
      return;
    }

    await _feedController.isFollowProcessing.runWithLoader(() async {
      await _toggleFeedFollow(item);
    });
  }

  Future<void> _toggleFeedFollow(Map<String, dynamic> item) async {
    final bool wasFollowed = item['is_followed'] ?? false;

    try {
      if (wasFollowed) {
        await _feedController.unfollowBusiness(item['follow_id'].toString());
      } else {
        await _feedController.followBusiness(item['business_id'].toString());
      }

      item['is_followed'] = !wasFollowed;
    } catch (e) {
      _handleError('Follow error: $e');
      // Consider showing an error toast to the user
    }
  }

  bool _isUserAuthenticated() {
    return getIt<DemoService>().isDemo;
  }

  void _handleError(String error) {
    // Use proper logging in production
    debugPrint(error);
    // Consider integrating with a crash analytics service
  }

  void _handleViewAllCategories() {
    _navigationController.updateTopTab(0);
  }

  void _handleViewAllFeeds() {
    _navigationController.updateTopTab(1);
  }

  void _handleViewAllRequirements() {
    _navigationController.updateBottomIndex(2);
  }
}

// Helper widget for consistent section styling
class SectionContainer extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onActionTap;
  final Widget child;

  const SectionContainer({
    super.key,
    required this.title,
    required this.actionText,
    required this.onActionTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: buildHeadingWithButton(
            title: title,
            rightText: actionText,
            onTap: onActionTap,
          ),
        ),
        child,
      ],
    );
  }
}

// Extension for cleaner loading state management
extension LoadingExtension on RxBool {
  Future<void> runWithLoader(Future<void> Function() action) async {
    value = true;
    try {
      await action();
    } finally {
      value = false;
    }
  }
}

// return Obx(() {
//   // If CatList or any subpage is open
//   if (controller.isSubPageOpen.value) {
//     return controller.homeContent;
//   }
//
//   // Otherwise show normal home with tabs
//   return topTabPages[controller.topTabIndex.value];
// });
