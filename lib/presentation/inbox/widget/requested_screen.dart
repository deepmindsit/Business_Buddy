import 'package:businessbuddy/utils/exported_path.dart';

class RequestedScreen extends StatefulWidget {
  const RequestedScreen({super.key});

  @override
  State<RequestedScreen> createState() => _RequestedScreenState();
}

class _RequestedScreenState extends State<RequestedScreen> {
  @override
  Widget build(BuildContext context) {
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
            Container(
              height: 40.h,
              margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: Colors.grey[700],
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Send'),
                  Tab(text: 'Receive'),
                ],
              ),
            ),

            // --- Tab Content ---
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(), // prevents
                children: [_buildSendList(), _buildReceivedList()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendList() {
    return ListView.separated(
      separatorBuilder: (context, index) =>
          Divider(height: 5, color: lightGrey),
      padding: const EdgeInsets.all(0),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          dense: true,
          leading: CircleAvatar(backgroundImage: AssetImage(Images.hotelImg)),
          title: CustomText(
            title: 'PizzaPoint',
            fontSize: 14.sp,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.bold,
          ),
          onTap: () {
            // Push a subpage within Inbox
            // navController.openSubPage(
            //   ChatDetailPage(chatId: index),
            // );
          },
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              // color: primaryColor,
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: CustomText(
              title: 'Requested',
              fontSize: 12.sp,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceivedList() {
    return ListView.separated(
      separatorBuilder: (context, index) =>
          SizedBox(height: 5,),
      padding: const EdgeInsets.all(12),
      itemCount: 10,
      itemBuilder: (context, index) {
        return AllDialogs().buildRequestCard(
          name: 'Ramesh Patil',
          title: 'Requirement Title: Looking for Food Ingredient Supplier',
          message:
              'You’ve received a new collaboration request from Restaurant.',
          date: '30 Oct 2025 • 10:42 AM',
          buttonText: 'Accept Request',
        );
      },
    );
  }
}
