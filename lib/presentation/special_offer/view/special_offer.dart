import 'package:businessbuddy/utils/exported_path.dart';

class SpecialOffer extends StatefulWidget {
  const SpecialOffer({super.key});

  @override
  State<SpecialOffer> createState() => _SpecialOfferState();
}

class _SpecialOfferState extends State<SpecialOffer> {
  final controller = getIt<SpecialOfferController>();

  @override
  void initState() {
    controller.getSpecialOffer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => controller.isLoading.isTrue
            ? LoadingWidget(color: primaryColor)
            : controller.offerList.isEmpty
            ? Center(
                child: CustomText(
                  title: 'No Data Found',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                itemCount: controller.offerList.length,
                itemBuilder: (_, i) {
                  final item = controller.offerList[i];

                  return OfferCard(data: item);
                },
              ),
      ),

      // SingleChildScrollView(
      //   child: Column(children: [OfferCard(), OfferCard()]),
      // ),
    );
  }
}
