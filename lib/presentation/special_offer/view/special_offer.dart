import 'package:businessbuddy/utils/exported_path.dart';

class SpecialOffer extends StatefulWidget {
  const SpecialOffer({super.key});

  @override
  State<SpecialOffer> createState() => _SpecialOfferState();
}

class _SpecialOfferState extends State<SpecialOffer> {
  final controller = getIt<SpecialOfferController>();

  @override
  void initState() {
    controller.resetData();
    controller.getSpecialOffer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => controller.isLoading.isTrue
            ? ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                itemCount: 5,
                itemBuilder: (_, i) => const FeedShimmer(),
              )
            : controller.offerList.isEmpty
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
                            title: 'Special Offers',
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
                      itemCount: controller.offerList.length,
                      itemBuilder: (_, i) {
                        final item = controller.offerList[i];
                        return OfferCard(data: item);
                      },
                    ),
                  ],
                ),
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
      // context: context,
      const FeedSheet(isFrom: 'offer'),
    );
  }
}
