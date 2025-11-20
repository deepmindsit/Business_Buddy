import 'package:businessbuddy/utils/exported_path.dart';

class BusinessPartner extends StatefulWidget {
  const BusinessPartner({super.key});

  @override
  State<BusinessPartner> createState() => _BusinessPartnerState();
}

class _BusinessPartnerState extends State<BusinessPartner> {
  final navController = getIt<NavigationController>();
  final controller = getIt<PartnerDataController>();

  @override
  void initState() {
    controller.getBusinessRequired();
    controller.getRequestedBusiness();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPartnerList(),
      floatingActionButton: Visibility(
        visible: getIt<DemoService>().isDemo,
        child: FloatingActionButton.small(
          backgroundColor: primaryColor,
          elevation: 0,
          foregroundColor: Colors.white,
          shape: CircleBorder(),
          onPressed: () {
            navController.openSubPage(AddRecruitment());
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildPartnerList() {
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
                Tab(text: 'Business Requirements', height: 35),
                Tab(text: 'Requested', height: 35),
              ],
            ),

            // --- Tab Content ---
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(), // prevents
                children: [_buildRequirement(), _buildRequested()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement() {
    return Obx(
      () => controller.isLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : controller.requirementList.isEmpty
          ? _buildEmptyPartner()
          : ListView.separated(
              separatorBuilder: (context, index) =>
                  Divider(height: 5, color: lightGrey),
              padding: const EdgeInsets.all(8),
              itemCount: controller.requirementList.length,
              itemBuilder: (context, index) {
                final data = controller.requirementList[index];
                return BusinessCard(data: data);
              },
            ),
    );
  }

  Widget _buildRequested() {
    return Obx(
      () => controller.isLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : controller.requestedBusinessList.isEmpty
          ? Center(
              child: CustomText(title: 'No Data Found', fontSize: 16.sp),
            )
          : ListView.separated(
              separatorBuilder: (context, index) =>
                  Divider(height: 5, color: lightGrey),
              padding: const EdgeInsets.all(8),
              itemCount: controller.requestedBusinessList.length,
              itemBuilder: (context, index) {
                final data = controller.requestedBusinessList[index];
                return BusinessCard(data: data, isRequested: true);
              },
            ),
    );
  }

  Widget _buildEmptyPartner() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.1.h),
            Center(
              child: Image.asset(
                Images.emptyBusiness,
                width: Get.width * 0.5.w,
              ),
            ),
            SizedBox(height: 20.h),
            CustomText(
              title: 'Looking for business partner?',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            // CustomButton(
            //   height: 60,
            //   width: Get.width.w,
            //   backgroundColor: primaryColor,
            //   isLoading: false.obs,
            //   onPressed: () {},
            //   text: 'See all open\nBusiness Requirements',
            // ),
            CustomButton(
              width: Get.width.w,
              backgroundColor: primaryColor,
              isLoading: false.obs,
              onPressed: () {
                if (!getIt<DemoService>().isDemo) {
                  ToastUtils.showLoginToast();
                  return;
                }
              },
              text: 'Post Recruitment',
            ),
          ],
        ),
      ),
    );
  }
}
