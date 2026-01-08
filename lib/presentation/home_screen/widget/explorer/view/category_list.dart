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
    controller.getBusinesses(widget.categoryId, isRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll is ScrollEndNotification &&
              scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50 &&
              controller.hastBusinessMore &&
              !controller.isBusinessLoadMore.value &&
              !controller.isBusinessLoading.value) {
            controller.getBusinesses(widget.categoryId);
          }
          return false;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// 🔹 Header
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

              /// 🔹 Category List
              Obx(() {
                if (controller.isBusinessLoading.isTrue) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    itemCount: 6, // shimmer items
                    itemBuilder: (_, i) => CatItemCardShimmer(),
                  );
                }

                /// 🔹 Empty State
                if (controller.businessList.isEmpty) {
                  return commonNoDataFound();
                }

                return ListView.builder(
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
                      phoneNumber: item['whatsapp_number'] ?? '',
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
                );
              }),

              /// 🔹 Pagination Loader
              Obx(
                () => controller.isBusinessLoadMore.value
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: LoadingWidget(color: primaryColor),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),

      //
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     // Local back + title
      //     Container(
      //       color: Colors.white,
      //       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      //       child: Row(
      //         spacing: 8,
      //         children: [
      //           GestureDetector(
      //             onTap: () => navController.goBack(),
      //             child: const Icon(Icons.arrow_back),
      //           ),
      //           CustomText(
      //             title: widget.categoryName,
      //             fontSize: 18.sp,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ],
      //       ),
      //     ),
      //     const Divider(),
      //     Expanded(
      //       child: Obx(
      //         () => controller.isBusinessLoading.isTrue
      //             // ? LoadingWidget(color: primaryColor)
      //             ? ListView.builder(
      //                 physics: NeverScrollableScrollPhysics(),
      //                 shrinkWrap: true,
      //                 padding: EdgeInsets.symmetric(horizontal: 8.w),
      //                 itemCount: 6, // shimmer items
      //                 itemBuilder: (_, i) => CatItemCardShimmer(),
      //               )
      //             : controller.businessList.isEmpty
      //             ? commonNoDataFound()
      //             : ListView.builder(
      //                 physics: NeverScrollableScrollPhysics(),
      //                 shrinkWrap: true,
      //                 padding: EdgeInsets.symmetric(horizontal: 8.w),
      //                 itemCount: controller.businessList.length,
      //                 itemBuilder: (_, i) {
      //                   final item = controller.businessList[i];
      //                   return CatItemCard(
      //                     offers: item['offers'] ?? [],
      //                     latitude: item['latitude'] ?? '',
      //                     isFollowed: item['is_followed'] ?? false,
      //                     isSelf: item['self_business'] ?? false,
      //                     longitude: item['longitude'] ?? '',
      //                     distance: item['distance']?.toString() ?? '',
      //                     name: item['name'] ?? '',
      //                     location: item['address'] ?? '',
      //                     category: item['category'] ?? '',
      //                     rating: item['total_rating']?.toString() ?? '0',
      //                     reviewCount: item['reviews_count']?.toString() ?? '0',
      //                     offerText: '${item['offers_count']} Offers ',
      //                     phoneNumber: item['mobile_number'] ?? '',
      //                     imagePath: item['image'] ?? '',
      //                     onCall: () {
      //                       if (!getIt<DemoService>().isDemo) {
      //                         ToastUtils.showLoginToast();
      //                         return;
      //                       }
      //                       if (item['mobile_number'] != null) {
      //                         makePhoneCall(item['mobile_number']);
      //                       }
      //                     },
      //                     onTap: () => navController.openSubPage(
      //                       CategoryDetailPage(
      //                         title: item['name'] ?? '',
      //                         businessId: item['id']?.toString() ?? '',
      //                       ),
      //                     ),
      //                     onFollow: () async {
      //                       print('object');
      //                       if (!getIt<DemoService>().isDemo) {
      //                         ToastUtils.showLoginToast();
      //                         return;
      //                       }
      //                       if (item['is_followed'] == true) {
      //                         await feedsController.unfollowBusiness(
      //                           item['follow_id'].toString(),
      //                         );
      //                       } else {
      //                         await feedsController.followBusiness(
      //                           item['id'].toString(),
      //                         );
      //                       }
      //
      //                       item['is_followed'] = !item['is_followed'];
      //                       await controller.getBusinesses(
      //                         widget.categoryId,
      //                         showLoading: false,
      //                       );
      //                     },
      //                   );
      //                 },
      //               ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
