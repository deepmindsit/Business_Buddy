import 'package:businessbuddy/utils/exported_path.dart';

class FollowingList extends StatefulWidget {
  const FollowingList({super.key});

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  final controller = getIt<ProfileController>();
  final businesses = [
    {
      'image': Images.hotelImg,
      'title': 'Hotel Jyoti Family....',
      'subtitle': 'Restaurant',
      'followers': '1200+ Followers',
    },
    {
      'image': Images.defaultImage,
      'title': 'Deepminds Infotech....',
      'subtitle': 'Information technology',
      'followers': '1200+ Followers',
    },
  ];

  @override
  void initState() {
    controller.getFollowList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => controller.isFollowLoading.isTrue
                  ? LoadingWidget(color: primaryColor)
                  : controller.followList.isEmpty
                  ? Center(
                      child: CustomText(title: 'No Following', fontSize: 14.sp),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(16.w),
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemCount: controller.followList.length,
                      itemBuilder: (_, index) {
                        final business = controller.followList[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.network(
                                    business['image']?.toString() ?? '',
                                    width: 50.w,
                                    height: 50.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        title:
                                            business['name']?.toString() ?? '',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        business['category']?.toString() ?? '',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      // Row(
                                      //   children: [
                                      //     Icon(
                                      //       Icons.people_alt_outlined,
                                      //       size: 14.sp,
                                      //       color: Colors.grey,
                                      //     ),
                                      //     SizedBox(width: 4.w),
                                      //     Text(
                                      //       business['followers']?.toString() ?? '',
                                      //       style: TextStyle(
                                      //         fontSize: 11.sp,
                                      //         color: Colors.grey[600],
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
              const Color(0XFFFF383C).withValues(alpha: 0.4),
              Colors.white.withValues(alpha: 0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      title: CustomText(
        title: "Following",
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
