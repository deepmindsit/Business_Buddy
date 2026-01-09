import '../utils/exported_path.dart';

import 'notification_controller.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final controller = getIt<NotificationController>();

  @override
  void initState() {
    controller.getNotificationInitial(isRefresh: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarPlain(title: "Notifications"),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return _buildShimmerLoader();
        }

        if (controller.notificationData.isEmpty) {
          return _buildEmptyState();
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
              controller.getNotificationLoadMore();
            }
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.notificationData.length,
                    itemBuilder: (context, index) {
                      final notification = controller.notificationData[index];
                      return NotificationTile(
                        notification: notification,
                        onTap: () async {
                          if (notification['data']['action'] == 'message') {
                            Get.back();
                            getIt<NavigationController>().openSubPage(
                              SingleChat(
                                chatId:
                                    notification['data']['chat_id']
                                        ?.toString() ??
                                    '',
                              ),
                            );
                          }
                          await controller.readNotification(
                            notification['id'].toString(),
                          );
                          // Get.toNamed(
                          //   Routes.newsDetails,
                          //   arguments: {
                          //     'newsId': notification['news_id'].toString(),
                          //   },
                          // );
                        },
                      );
                    },
                  ),
                  controller.notificationData.isEmpty
                      ? const SizedBox()
                      : buildLoader(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildLoader() {
    if (controller.isMoreLoading.value) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: LoadingWidget(color: primaryColor),
      );
    } else if (!controller.hasNextPage.value) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text('No more data')),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Images.noNotification, width: Get.width * 0.35.w),
          SizedBox(height: 16.sp),
          CustomText(
            title: 'No Notifications!',
            textAlign: TextAlign.center,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            style: TextStyle(),
          ),
          SizedBox(height: 8.sp),
          CustomText(
            title: 'You don\'t have any notifications yet.',
            textAlign: TextAlign.center,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          height: Get.height * 0.1,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String body;
  final String time;
  final bool isRead;
  final IconData icon;

  NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.icon,
  });
}

class NotificationTile extends StatelessWidget {
  final dynamic notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: notification['is_read'].toString() == '1'
          ? Colors.white
          : Colors.blue[50],
      child: ListTile(
        // leading: WidgetZoom(
        //   heroAnimationTag: 'tag ${notification['image']}',
        //   zoomWidget: ClipRRect(
        //     borderRadius: BorderRadius.circular(8.r),
        //     child: Image.network(
        //       notification['image'] ??
        //           '',
        //       fit: BoxFit.contain,
        //       width: 40.w,
        //       errorBuilder:
        //           (context, error, stackTrace) => Container(
        //         color: Colors.grey.shade300,
        //         alignment: Alignment.center,
        //         child: Icon(
        //           Icons.broken_image,
        //           color: Colors.red,
        //           size: 40.w,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        title: CustomText(
          title: notification['title'] ?? '',
          fontSize: 14.sp,
          textAlign: TextAlign.start,
          maxLines: 2,
          fontWeight: notification['is_read'].toString() == '1'
              ? FontWeight.normal
              : FontWeight.bold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: notification['message'] ?? '',
              fontSize: 12.sp,
              color: Colors.grey,
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
            SizedBox(height: 4),
            Text(
              notification['created_at'] ?? '',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: notification['is_read'].toString() == '1'
            ? null
            : Icon(Icons.circle, color: Colors.blue, size: 12),
        onTap: onTap,
      ),
    );
  }
}
