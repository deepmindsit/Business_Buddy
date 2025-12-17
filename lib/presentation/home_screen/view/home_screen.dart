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

  // @override
  // void initState() {
  //   super.initState();
  //   _initializeData();
  // }
  //
  // Future<void> _initializeData() async {
  //   print('in 1 home screen');
  //    getIt<SearchNewController>().getLiveLocation();
  //   print('in 2 home screen');
  //   // await _homeController.requestLocationPermission();
  //   location();
  //   _homeController.getHomeApi();
  // }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    _homeController.isMainLoading.value = true;
    final locationController = getIt<LocationController>();
    await locationController.fetchInitialLocation();

    final searchController = getIt<SearchNewController>();
    searchController.getLiveLocation();

    await _homeController.getHomeApi();
    _homeController.isMainLoading.value = false;
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
        _buildRequirementsSection(),
        _buildFeedsSection(),
      ],
    );
  }

  Widget _buildSlider() {
    return Obx(
      () => _homeController.isMainLoading.isTrue
          ? _buildSliderLoader()
          : AnimationLimiter(
              child: AnimationConfiguration.staggeredList(
                position: 0,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: CustomCarouselSlider(
                      height: 0.2.h,
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      radius: 16.r,
                      imageList: _homeController.sliderList,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildCategorySection() {
    return Obx(
      () => _homeController.isMainLoading.isTrue
          ? buildCategoryLoader()
          : SectionContainer(
              title: 'Categories',
              actionText: 'View More',
              onActionTap: _handleViewAllCategories,
              child: AnimationLimiter(
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 20.w,
                    mainAxisSpacing: 0.h,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _homeController.categoryList.length,
                  itemBuilder: (context, index) {
                    final category = _homeController.categoryList[index];
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 4,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
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
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildFeedsSection() {
    return Obx(
      () => _homeController.isMainLoading.isTrue
          ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemCount: 5, // shimmer count
              itemBuilder: (_, i) => const FeedShimmer(),
            )
          : SectionContainer(
              title: 'Feeds',
              actionText: 'View More',
              onActionTap: _handleViewAllFeeds,
              child: AnimationLimiter(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  itemCount: _homeController.feedsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final feedItem = _homeController.feedsList[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: _buildFeedItem(feedItem)),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildFeedItem(Map<String, dynamic> item) {
    if (item['type'] == 'offer') {
      return OfferCard(
        data: item,
        onLike: () => handleOfferLike(
          item,
          () => _homeController.getHomeApi(showLoading: false),
        ),
      );
    }

    return FeedCard(
      data: item,
      onLike: () => handleFeedLike(item, () => _homeController.getHomeApi()),
      onFollow: () => _handleFeedFollow(item),
    );
  }

  Widget _buildRequirementsSection() {
    return Obx(
      () => _homeController.isMainLoading.isTrue
          ? ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(8),
              itemCount: 6,
              separatorBuilder: (_, __) => SizedBox(height: 10),
              itemBuilder: (context, index) => const BusinessCardShimmer(),
            )
          : SectionContainer(
              title: 'Business Requirements',
              actionText: 'View More',
              onActionTap: _handleViewAllRequirements,
              child: ListView.separated(
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
      height: Get.height * 0.2.h,
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

  Future<void> _handleFeedFollow(Map<String, dynamic> item) async {
    if (_feedController.isFollowProcessing.value) return;

    if (!isUserAuthenticated()) {
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
      await _homeController.getHomeApi(showLoading: false);
    } catch (e) {
      handleError('Follow error: $e');
      // Consider showing an error toast to the user
    }
  }

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
  //       () => _homeController.getHomeApi(showLoading: false),
  //     );
  //   });
  // }

  // bool _isUserAuthenticated() {
  //   return getIt<DemoService>().isDemo;
  // }

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
