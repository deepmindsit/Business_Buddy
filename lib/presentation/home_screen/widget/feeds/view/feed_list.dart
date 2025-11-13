import 'package:businessbuddy/utils/exported_path.dart';

class NewFeed extends StatefulWidget {
  const NewFeed({super.key});

  @override
  State<NewFeed> createState() => _NewFeedState();
}

class _NewFeedState extends State<NewFeed> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [FeedCard(), FeedCard()]),
    );
  }
}
