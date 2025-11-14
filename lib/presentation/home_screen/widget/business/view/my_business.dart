import 'package:businessbuddy/utils/exported_path.dart';

class LboScreen extends StatefulWidget {
  const LboScreen({super.key});

  @override
  State<LboScreen> createState() => _LboScreenState();
}

class _LboScreenState extends State<LboScreen> {
  final navController = getIt<NavigationController>();
  final controller = getIt<LBOController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMyBusinesses();
      controller.selectedBusiness.value = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => Padding(
          padding: EdgeInsets.all(12.w),
          child: controller.isBusinessLoading.isTrue
              ? LoadingWidget(color: primaryColor)
              : controller.businessList.isEmpty
              ? _buildEmptyLBO()
              : _buildBusinessList(),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _buildExpandableFab(),
    );
  }

  // ---------------- FAB -----------------
  Widget _buildExpandableFab() {
    return Obx(() {
      if (controller.isBusinessApproved.value == '0') {
        return const SizedBox();
      }

      return ExpandableFab(
        distance: 70,
        type: ExpandableFabType.up,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          fabSize: ExpandableFabSize.small,
          child: const Icon(Icons.add, color: Colors.white, size: 24),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          elevation: 0,
          // elevation: 8,
        ),
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
          fabSize: ExpandableFabSize.small,
          child: const Icon(Icons.close, color: Colors.white, size: 20),
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          // elevation: 6,
        ),
        children: [
          _buildFabChild(
            icon: Icons.post_add,
            text: 'Post',
            color: Colors.black,
            onPressed: () => Get.toNamed(Routes.addPost),
          ),
          _buildFabChild(
            icon: Icons.local_offer,
            text: 'Offer',
            color: Colors.red,
            onPressed: () => Get.toNamed(Routes.addOffer),
          ),
        ],
      );
    });
  }

  // Helper method to create consistent FAB children
  Widget _buildFabChild({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: FloatingActionButton.extended(
        heroTag: null,
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: color,
        foregroundColor: Colors.white,
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  // ---------------- MAIN CONTENT -----------------
  Widget _buildBusinessList() {
    return SingleChildScrollView(
      child: Obx(
        () => Column(
          spacing: 8.h,
          children: [
            _buildAddBusinessButton(),
            _buildBusinessListBody(),
            if (controller.isBusinessApproved.value == '0') _pendingBusiness(),
            if (controller.isBusinessApproved.value == '1')
              _buildPostAndOffers(),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAddBusinessButton() {
    return GestureDetector(
      onTap: () => navController.openSubPage(const AddBusiness()),
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: CustomText(
          title: 'Add Business',
          fontSize: 16.sp,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBusinessListBody() {
    return SizedBox(
      height: 60.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.businessList.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedBusiness.value == index;
            final business = controller.businessList[index];

            return GestureDetector(
              onTap: () {
                controller.selectedBusiness.value = index;
                controller.selectedBusinessId.value = business['id'].toString();
                controller.postList.value = business['posts'] ?? [];
                controller.offerList.value = business['offers'] ?? [];
                controller.isBusinessApproved.value = business['is_approved'];
                if (controller.isBusinessApproved.value == '1') {
                  Get.toNamed(
                    Routes.businessDetails,
                    arguments: {'businessId': business['id'].toString()},
                  );
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: Get.width * 0.7.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: isSelected ? primaryColor : Colors.grey.shade200,
                    width: isSelected ? 1.8 : 1,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: Colors.grey.shade100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: FadeInImage(
                          placeholder: const AssetImage(Images.logo),
                          image: NetworkImage(business['image'] ?? ''),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              Images.defaultImage,
                              fit: BoxFit.contain,
                            );
                          },
                          fit: BoxFit.cover,
                          placeholderFit: BoxFit.contain,
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            title: business['name'] ?? '',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            maxLines: 1,
                          ),
                          SizedBox(height: 4.h),
                          CustomText(
                            title: business['category'] ?? '',
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildPostAndOffers() {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Tab Bar ---
            TabBar(
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Post'),
                Tab(text: 'Special Offer'),
              ],
            ),

            // --- Tab Content ---
            Container(
              padding: EdgeInsets.all(10.w),
              height: Get.height * 0.45.h,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(), // prevents
                children: [
                  buildGridImages(controller.postList, 'post'),
                  buildGridImages(controller.offerList, 'offer'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyLBO() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: Get.height * 0.1.h),
            Center(
              child: Image.asset(Images.noBusiness, width: Get.width * 0.5.w),
            ),
            SizedBox(height: 20.h),
            CustomText(
              title: 'No Business Added Yet!',
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 10.h),
            CustomText(
              title:
                  'Start by adding your business to showcase your brand, attract investors, and connect with potential partners.',
              fontSize: 14.sp,
              maxLines: 5,
            ),
            SizedBox(height: 20.h),
            CustomButton(
              width: Get.width.w,
              backgroundColor: primaryColor,
              isLoading: false.obs,
              onPressed: () => navController.openSubPage(AddBusiness()),
              text: 'Add Business',
            ),
          ],
        ),
      ),
    );
  }

  Widget _pendingBusiness() {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.1),
                  width: 2,
                ),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedLoading01,
                size: 12,
                color: primaryColor.withValues(alpha: 0.5),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Approval Pending",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "Your business is currently under review. We'll notify you once the verification process is complete.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
