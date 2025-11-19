import 'package:businessbuddy/utils/exported_path.dart';

class NewFeed extends StatefulWidget {
  const NewFeed({super.key});

  @override
  State<NewFeed> createState() => _NewFeedState();
}

class _NewFeedState extends State<NewFeed> {
  final controller = getIt<FeedsController>();

  @override
  void initState() {
    controller.getFeeds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : controller.feedList.isEmpty
          ? Center(
              child: CustomText(
                title: 'No Data Found',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            )
          : ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemCount: controller.feedList.length,
              itemBuilder: (_, i) {
                final item = controller.feedList[i];

                return item['type'] == 'offer'
                    ? OfferCard(data: item)
                    : FeedCard(data: item);
              },
            ),
    );

    // SingleChildScrollView(child: Column(children: [FeedCard(), FeedCard()]));
  }
}
