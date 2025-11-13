import 'package:businessbuddy/utils/exported_path.dart';

class BusinessPartner extends StatefulWidget {
  const BusinessPartner({super.key});

  @override
  State<BusinessPartner> createState() => _BusinessPartnerState();
}

class _BusinessPartnerState extends State<BusinessPartner> {
  final navController = getIt<NavigationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPartnerList(),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        onPressed: () {
          navController.openSubPage(AddRecruitment());
        },
        child: Icon(Icons.add),
      ),
      // SingleChildScrollView(
      //   child: Column(children: [
      //     _buildPartnerList()
      //     // _buildEmptyPartner()
      //   ]),
      // ),
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
    return ListView.separated(
      separatorBuilder: (context, index) =>
          Divider(height: 5, color: lightGrey),
      padding: const EdgeInsets.all(8),
      itemCount: 10,
      itemBuilder: (context, index) {
        return BusinessCard(status: 'Basic');
      },
    );
  }

  Widget _buildRequested() {
    return ListView.separated(
      separatorBuilder: (context, index) =>
          Divider(height: 5, color: lightGrey),
      padding: const EdgeInsets.all(8),
      itemCount: 10,
      itemBuilder: (context, index) {
        return index.isEven
            ? BusinessCard(status: 'Requested')
            : BusinessCard(status: 'Approved');
      },
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
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            CustomButton(
              height: 60,
              width: Get.width.w,
              backgroundColor: primaryColor,
              isLoading: false.obs,
              onPressed: () {},
              text: 'See all open\nBusiness Requirements',
            ),
            CustomButton(
              width: Get.width.w,
              backgroundColor: Colors.black,
              isLoading: false.obs,
              onPressed: () {},
              text: 'Post Recruitment',
            ),
          ],
        ),
      ),
    );
  }
}
