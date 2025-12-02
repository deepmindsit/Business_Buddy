import 'package:businessbuddy/utils/exported_path.dart';

class SingleChat extends StatefulWidget {
  const SingleChat({super.key, required this.chatId});
  final String chatId;
  @override
  State<SingleChat> createState() => _SingleChatState();
}

class _SingleChatState extends State<SingleChat> {
  final navController = getIt<NavigationController>();
  final controller = getIt<InboxController>();

  @override
  void initState() {
    controller.getSingleChat(widget.chatId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => controller.isSingleLoading.isTrue
            ? LoadingWidget(color: primaryColor)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Local back + title
                  _buildHeader(),
                  const Divider(),
                  // Chat messages
                  _buildAllChat(),

                  // Text field at bottom
                  _buildTextField(),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
            title: controller.singleChat['business_requirement_name'] ?? '',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        // color: Colors.grey.shade100,
        border: const Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: TextField(
                controller: controller.msgController,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (value) async {
                  if (value.trim().isNotEmpty) {
                    await controller.sendMsg(widget.chatId);
                  }
                },
              ),
            ),
          ),

          Obx(
            () => controller.isSendLoading.isTrue
                ? LoadingWidget(color: primaryColor, size: 20.r)
                : IconButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedSent,
                      color: primaryColor,
                    ),
                    onPressed: () async {
                      if (controller.msgController.text.isNotEmpty) {
                        await controller.sendMsg(widget.chatId);
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllChat() {
    final chatList = controller.singleChat['messages'] ?? [];
    return Expanded(
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.all(12),
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final message = chatList[index];
          final isMe = message['self'] == true;

          return Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Get.width * 0.75.w),
              child: IntrinsicWidth(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  color: !isMe
                      ? primaryColor.withValues(alpha: 0.05)
                      : Colors.grey.shade200,
                  surfaceTintColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        // if (chat['document'] == 'yes') _buildFileAttachment(),
                        Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: CustomText(
                            title: message['message'].toString(),
                            fontSize: 13.sp,
                            maxLines: 10,
                            color: Colors.black87,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomText(
                            title: message['created_at'],
                            textAlign: TextAlign.start,
                            // DateFormat(
                            //   'hh mm a',
                            // ).format(DateTime.parse(message['created_at'])),
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
