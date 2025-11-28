import 'package:businessbuddy/utils/exported_path.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  final controller = getIt<ExplorerController>();
  final navController = getIt<NavigationController>();

  @override
  void initState() {
    controller.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: CustomText(
              title: 'Category',
              fontSize: 18.sp,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: CustomText(
              title: 'Find nearby stores, services & offers with one tap.',
              fontSize: 14.sp,
              color: textLightGrey,
              textAlign: TextAlign.start,
            ),
          ),

          Expanded(
            child: Obx(
              () => controller.isLoading.isTrue
                  // ? LoadingWidget(color: primaryColor)
                  ? buildCategoryLoader()
                  : controller.categories.isEmpty
                  ? Center(
                      child: CustomText(
                        title: 'No Category Found',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.only(
                        top: 8.h,
                      ).copyWith(right: 8.w, left: 8.w),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 8.h,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        final cat = controller.categories[index];
                        return GestureDetector(
                          onTap: () {
                            navController.openSubPage(
                              CategoryList(
                                categoryId: cat['id'].toString(),
                                categoryName: cat['name'].toString(),
                              ),
                            );
                          },
                          child: CategoryCard(
                            image: cat['image'].toString(),
                            name: cat['name'].toString(),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildCategoryLoader() {
  return GridView.builder(
    padding: EdgeInsets.only(top: 8.h).copyWith(right: 8.w, left: 8.w),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 8.h,
      childAspectRatio: 0.7,
    ),
    itemCount: 8, // Show 8 shimmer items
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            // Image placeholder
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 8.h),
            // Text placeholder
            Container(
              width: 60.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 4.h),
            // Secondary text placeholder
            Container(
              width: 40.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      );
    },
  );
}
