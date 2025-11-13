import 'package:businessbuddy/utils/exported_path.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final navController = getIt<NavigationController>();
  @override
  Widget build(BuildContext context) {
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
          subtitle: CustomText(
            title: 'Hi Gaurav — Today only: 30% off on all la.....',
            fontSize: 12.sp,
            textAlign: TextAlign.start,
            // maxLines: 1,
          ),
          onTap: () {
            // Push a subpage within Inbox
            navController.openSubPage(SingleChat());
          },
          trailing: CustomText(
            title: '2h ago',
            fontSize: 12.sp,
            textAlign: TextAlign.start,
          ),
        );
      },
    );
  }
}
