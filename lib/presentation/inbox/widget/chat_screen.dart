import 'package:businessbuddy/utils/exported_path.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final navController = getIt<NavigationController>();
  final controller = getIt<InboxController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isChatLoading.isTrue
          ? const ChatListShimmer()
          : controller.allChats.isEmpty
          ? commonNoDataFound()
          : ListView.separated(
              separatorBuilder: (context, index) =>
                  Divider(height: 5, color: lightGrey),
              padding: const EdgeInsets.all(0),
              itemCount: controller.allChats.length,
              itemBuilder: (context, index) {
                final chat = controller.allChats[index];
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      chat['self_business_requirement'] == true
                          ? chat['user_profile_image'] ?? ''
                          : chat['business_requirement_user_profile_image'] ??
                                '',
                    ),
                    //Images.hotelImg),
                  ),
                  title: CustomText(
                    title: chat['business_requirement_name'] ?? '',
                    fontSize: 14.sp,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: CustomText(
                    title: chat['self_business_requirement'] == true
                        ? chat['user_name'] ?? ''
                        : chat['business_requirement_user_name'] ?? '',
                    fontSize: 12.sp,
                    textAlign: TextAlign.start,
                    // maxLines: 1,
                  ),
                  onTap: () {
                    // Push a subpage within Inbox
                    navController.openSubPage(
                      SingleChat(
                        chatId:
                            chat['business_requirement_chat_id']?.toString() ??
                            '',
                      ),
                    );
                  },
                  // trailing: CustomText(
                  //   title: '2h ago',
                  //   fontSize: 12.sp,
                  //   textAlign: TextAlign.start,
                  // ),
                );
              },
            ),
    );
  }
}

class ChatListShimmer extends StatelessWidget {
  const ChatListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 8,
      separatorBuilder: (_, __) => Divider(height: 5, color: lightGrey),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: CircleAvatar(radius: 24.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 14.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 12.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
