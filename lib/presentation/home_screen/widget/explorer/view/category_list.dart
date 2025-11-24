import 'package:businessbuddy/utils/exported_path.dart';

class CategoryList extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const CategoryList({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final navController = getIt<NavigationController>();
  final controller = getIt<ExplorerController>();
  final feedsController = getIt<FeedsController>();

  @override
  void initState() {
    controller.getBusinesses(widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Local back + title
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Row(
            spacing: 8,
            children: [
              GestureDetector(
                onTap: () => navController.goBack(),
                child: const Icon(Icons.arrow_back),
              ),
              CustomText(
                title: widget.categoryName,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: Obx(
            () => controller.isBusinessLoading.isTrue
                ? LoadingWidget(color: primaryColor)
                : controller.businessList.isEmpty
                ? Center(
                    child: CustomText(
                      title: 'No Data Found',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    itemCount: controller.businessList.length,
                    itemBuilder: (_, i) {
                      final item = controller.businessList[i];
                      return CatItemCard(
                        offers: item['offers'] ?? [],
                        latitude: item['latitude'] ?? '',
                        isFollowed: item['is_followed'] ?? false,
                        isSelf: item['self_business'] ?? false,
                        longitude: item['longitude'] ?? '',
                        distance: item['distance']?.toString() ?? '',
                        name: item['name'] ?? '',
                        location: item['address'] ?? '',
                        category: item['category'] ?? '',
                        rating: item['total_rating']?.toString() ?? '0',
                        reviewCount: item['reviews_count']?.toString() ?? '0',
                        offerText: '${item['offers_count']} Offers ',
                        phoneNumber: item['mobile_number'] ?? '',
                        imagePath: item['image'] ?? '',
                        onCall: () {
                          if (!getIt<DemoService>().isDemo) {
                            ToastUtils.showLoginToast();
                            return;
                          }
                          if (item['mobile_number'] != null) {
                            makePhoneCall(item['mobile_number']);
                          }
                        },
                        onTap: () => navController.openSubPage(
                          CategoryDetailPage(
                            title: item['name'] ?? '',
                            businessId: item['id']?.toString() ?? '',
                          ),
                        ),
                        onFollow: () async {
                          print('object');
                          if (!getIt<DemoService>().isDemo) {
                            ToastUtils.showLoginToast();
                            return;
                          }
                          if (item['is_followed'] == true) {
                            await feedsController.unfollowBusiness(
                              item['follow_id'].toString(),
                            );
                          } else {
                            await feedsController.followBusiness(
                              item['id'].toString(),
                            );
                          }

                          item['is_followed'] = !item['is_followed'];
                          await controller.getBusinesses(
                            widget.categoryId,
                            showLoading: false,
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
