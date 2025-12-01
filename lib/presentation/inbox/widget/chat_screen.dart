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
          ? LoadingWidget(color: primaryColor)
          : controller.allChats.isEmpty
          ? Center(
              child: CustomText(title: 'No Data Found', fontSize: 14.sp),
            )
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
