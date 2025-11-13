import 'package:businessbuddy/utils/exported_path.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(color: lightGrey),
              itemCount: 3,
              itemBuilder: (_, index) => _buildNotificationTile(index),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0XFFFF383C).withValues(alpha: 0.4),
              Colors.white.withValues(alpha: 0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      title: CustomText(
        title: "Notifications",
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNotificationTile(int index) {
    // final data = notificationData.notificationList[index];
    // final isUnread = data['is_read'].toString() == '0';
    // final imageUrl = data['image'];
    // final isDefaultImage = imageUrl == notificationData.defaultImage.value;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: Colors.transparent,
        dense: true,
        splashColor: Colors.transparent,
        title: CustomText(
          title:
              '“Flat 20% OFF today! Don’t miss out on your favorite pizza combo.”',
          fontSize: 14.sp,
          maxLines: 2,
          color: textDarkGrey,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            height: 1.2,
          ),
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: FadeInImage(
            image: AssetImage(Images.defaultImage),
            placeholder: const NetworkImage(Images.defaultImage),
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.network(Images.defaultImage, fit: BoxFit.cover);
            },
            fit: BoxFit.cover,
            placeholderFit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
