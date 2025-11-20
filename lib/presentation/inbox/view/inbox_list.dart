import 'package:businessbuddy/utils/exported_path.dart';

class InboxList extends StatefulWidget {
  const InboxList({super.key});

  @override
  State<InboxList> createState() => _InboxListState();
}

class _InboxListState extends State<InboxList> {
  final navController = getIt<NavigationController>();
  final controller = getIt<InboxController>();

  @override
  void initState() {
    controller.getReceiveBusinessRequest();
    getIt<PartnerDataController>().getRequestedBusiness();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
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
                tabs: [
                  Tab(text: 'Chat', height: 35),
                  Tab(text: 'Request', height: 35),
                ],
              ),

              // --- Tab Content ---
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(), // prevents
                  children: [ChatScreen(), RequestedScreen()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildChatList() {
  //   return ListView.separated(
  //     separatorBuilder: (context, index) =>
  //         Divider(height: 5, color: lightGrey),
  //     padding: const EdgeInsets.all(0),
  //     itemCount: 10,
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         dense: true,
  //         leading: CircleAvatar(backgroundImage: AssetImage(Images.hotelImg)),
  //         title: CustomText(
  //           title: 'PizzaPoint',
  //           fontSize: 14.sp,
  //           textAlign: TextAlign.start,
  //           fontWeight: FontWeight.bold,
  //         ),
  //         subtitle: CustomText(
  //           title: 'Hi Gaurav — Today only: 30% off on all la.....',
  //           fontSize: 12.sp,
  //           textAlign: TextAlign.start,
  //           // maxLines: 1,
  //         ),
  //         onTap: () {
  //           // Push a subpage within Inbox
  //           navController.openSubPage(SingleChat());
  //         },
  //         trailing: CustomText(
  //           title: '2h ago',
  //           fontSize: 12.sp,
  //           textAlign: TextAlign.start,
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildRequestedList() {
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

  Widget _buildEmptyInbox() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.1.h),
            Center(
              child: Image.asset(Images.noBusiness, width: Get.width * 0.5.w),
            ),
            SizedBox(height: 20.h),
            CustomText(
              title: 'No Messages Yet!',
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 10.h),
            CustomText(
              title:
                  'Start connecting with local businesses and users to receive messages here.',
              fontSize: 14.sp,
              maxLines: 5,
            ),
            SizedBox(height: 20.h),
            CustomButton(
              width: Get.width.w,
              backgroundColor: primaryColor,
              isLoading: false.obs,
              onPressed: () {},
              text: 'Explore Businesses',
            ),
          ],
        ),
      ),
    );
  }
}
