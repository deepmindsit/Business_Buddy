import 'package:businessbuddy/presentation/inbox/controller/inbox_controller.dart';
import 'package:businessbuddy/utils/exported_path.dart';
import 'package:intl/intl.dart';

class SingleChat extends StatefulWidget {
  const SingleChat({super.key});

  @override
  State<SingleChat> createState() => _SingleChatState();
}

class _SingleChatState extends State<SingleChat> {
  final navController = getIt<NavigationController>();
  final controller = getIt<InboxController>();

  @override
  Widget build(BuildContext context) {
    return
    //   Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: AppBar(
    //     surfaceTintColor: Colors.white,
    //     toolbarHeight: 0,
    //     backgroundColor: Colors.red,
    //     leading: GestureDetector(
    //       onTap: () => navController.goBack(),
    //       child: const Icon(Icons.arrow_back),
    //     ),
    //     title: CustomText(
    //       title: 'PizzaPoint',
    //       fontSize: 18.sp,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    // );
    Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Local back + title
          Container(
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
                  title: 'PizzaPoint',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          const Divider(),
          // Chat messages
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message =
                    controller.messages[controller.messages.length - 1 - index];
                final isMe = message['isMe'] as bool;

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
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
                              CustomText(
                                title: message['text'].toString(),
                                fontSize: 13,
                                maxLines: 10,
                                color: Colors.black87,
                                textAlign: TextAlign.start,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: CustomText(
                                  title: DateFormat(
                                    'hh mm a',
                                  ).format(DateTime.now()),
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
          ),

          // Text field at bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: const Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) {},
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: primaryColor),
                  onPressed: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
