import 'package:businessbuddy/utils/exported_path.dart';

Widget buildReviewTile({
  required String userName,
  required String review,
  required int rating,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 20.r,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: AssetImage(Images.hotelImg),
      ),
      SizedBox(width: 12.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: userName,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            SizedBox(height: 4.h),
            CustomText(
              title: review,
              textAlign: TextAlign.start,
              fontSize: 13.sp,
              color: Colors.grey.shade700,
              maxLines: 20,
            ),
            buildStarRating(rating),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    ],
  );
}

Widget buildStarRating(int rating) {
  return Row(
    children: List.generate(5, (index) {
      return Icon(
        Icons.star_rounded,
        color: index < rating ? Colors.amber : Colors.grey.shade300,
        size: 16.sp,
      );
    }),
  );
}

Widget buildGridImages(dynamic data, String type) {
  if (data.isEmpty) {
    return Center(
      child: Text(
        'No items available',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      ),
    );
  }
  return GridView.builder(
    padding: EdgeInsets.only(top: 8.h),
    itemCount: data.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 8.w,
      crossAxisSpacing: 8.w,
      childAspectRatio: 1,
    ),
    itemBuilder: (context, index) {
      final image = data[index];
      return GestureDetector(
        onTap: () {
          showPostBottomSheet(image['id'].toString(), type);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: FadeInImage.assetNetwork(
            placeholder: Images.defaultImage,
            image: image['image'] ?? '',
            fit: BoxFit.cover,
            imageErrorBuilder: (_, __, ___) =>
                Image.asset(Images.defaultImage, fit: BoxFit.cover),
          ),
        ),
      );
    },
  );
}

void showPostBottomSheet(String postId, String type) async {
  final controller = getIt<LBOController>();
  if (type == 'post') await controller.getSinglePost(postId);
  if (type == 'offer') await controller.getSingleOffer(postId);
  if (type == 'post') {
    _showPost(controller);
    // Get.bottomSheet(
    //   ConstrainedBox(
    //     constraints: BoxConstraints(maxHeight: Get.height * 0.7.h),
    //     child: Container(
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    //       ),
    //       padding: EdgeInsets.all(16.w),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           AspectRatio(
    //             aspectRatio: 1,
    //             child: ClipRRect(
    //               borderRadius: BorderRadius.circular(12.r),
    //               child: Image.network(
    //                 controller.singlePost['image'].toString(),
    //                 width: double.infinity,
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //           ),
    //           SizedBox(height: 12),
    //           Text(
    //             controller.singlePost['details'] ?? "",
    //             style: TextStyle(fontSize: 14),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    //   isScrollControlled: true,
    // );
  } else {
    // Get.bottomSheet(
    //   ConstrainedBox(
    //     constraints: BoxConstraints(maxHeight: Get.height * 0.7.h),
    //     child: Container(
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    //       ),
    //       padding: EdgeInsets.all(16),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           ClipRRect(
    //             borderRadius: BorderRadius.circular(12.r),
    //             child: Image.network(
    //               controller.singleOffer['image'].toString(),
    //               width: double.infinity,
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //           SizedBox(height: 12),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               CustomText(
    //                 title: controller.singleOffer['business_name'].toString(),
    //                 fontSize: 14.sp,
    //                 fontWeight: FontWeight.w600,
    //                 textAlign: TextAlign.start,
    //                 color: Colors.black87,
    //               ),
    //               SizedBox(height: 2.h),
    //               CustomText(
    //                 title: controller.singleOffer['details'] ?? "",
    //                 textAlign: TextAlign.start,
    //                 fontSize: 14.sp,
    //                 maxLines: 10,
    //               ),
    //               SizedBox(height: 6.h),
    //               Row(
    //                 children: [
    //                   Icon(
    //                     Icons.calendar_today_outlined,
    //                     size: 14.sp,
    //                     color: Colors.grey,
    //                   ),
    //                   SizedBox(width: 4.w),
    //                   CustomText(
    //                     title:
    //                         '${controller.singleOffer['start_date'] ?? ''} to ${controller.singleOffer['end_date'] ?? ''} ',
    //                     fontSize: 13.sp,
    //                     color: Colors.black54,
    //                     textAlign: TextAlign.start,
    //                   ),
    //                 ],
    //               ),
    //               SizedBox(height: 4.h),
    //
    //               Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: controller.singleOffer['highlight_points']
    //                     .map<Widget>((v) {
    //                       return buildBulletPoint(text: v);
    //                     })
    //                     .toList(),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    //   isScrollControlled: true,
    // );
    _showOffer(controller);
  }
}

Future<dynamic> _showOffer(LBOController controller) {
  return Get.bottomSheet(
    ConstrainedBox(
      constraints: BoxConstraints(maxHeight: Get.height * 0.75.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with drag indicator
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with better styling
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(width: 0.5, color: Colors.grey),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: FadeInImage(
                            placeholder: const AssetImage(Images.defaultImage),
                            image: NetworkImage(
                              controller.singleOffer['image'].toString(),
                            ),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                Images.defaultImage,
                                fit: BoxFit.contain,
                              );
                            },
                            fit: BoxFit.contain,
                            placeholderFit: BoxFit.contain,
                            fadeInDuration: const Duration(milliseconds: 300),
                          ),
                        ),

                        // Image.network(
                        //   controller.singleOffer['image'].toString(),
                        //   width: double.infinity,
                        //   // height: 180.h,
                        //   fit: BoxFit.cover,
                        //   errorBuilder: (context, error, stackTrace) {
                        //     return Container(
                        //       height: 180,
                        //       color: Colors.grey.shade200,
                        //       child: Icon(
                        //         Icons.image_not_supported_outlined,
                        //         color: Colors.grey.shade400,
                        //         size: 40,
                        //       ),
                        //     );
                        //   },
                        // ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Business Name
                    Text(
                      controller.singleOffer['business_name'].toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 12),

                    // Details
                    if (controller.singleOffer['details'] != null &&
                        controller.singleOffer['details'].toString().isNotEmpty)
                      Text(
                        controller.singleOffer['details'].toString(),
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.grey.shade700,
                        ),
                      ),

                    SizedBox(height: 16),

                    // Date Range
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.shade100,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Colors.blue.shade700,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${controller.singleOffer['start_date'] ?? ''} to ${controller.singleOffer['end_date'] ?? ''}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Highlights Section
                    if (controller.singleOffer['highlight_points'] != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Highlights',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: controller.singleOffer['highlight_points']
                                .map<Widget>((v) => buildHighlightPoint(v))
                                .toList(),
                          ),
                        ],
                      ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

Future<dynamic> _showPost(LBOController controller) {
  return Get.bottomSheet(
    ConstrainedBox(
      constraints: BoxConstraints(maxHeight: Get.height * 0.75.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.15),
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with enhanced styling
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: FadeInImage(
                            placeholder: const AssetImage(Images.defaultImage),
                            image: NetworkImage(
                              controller.singlePost['image'] ?? '',
                            ),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                Images.defaultImage,
                                fit: BoxFit.contain,
                              );
                            },
                            fit: BoxFit.contain,
                            placeholderFit: BoxFit.contain,
                            fadeInDuration: const Duration(milliseconds: 300),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // Content section
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section title
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.description_outlined,
                                  size: 16,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Post Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12),

                          // Details text
                          Text(
                            controller.singlePost['details']?.toString() ??
                                "No description available",
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Colors.grey.shade700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

Widget buildHighlightPoint(String text) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6, right: 12),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    ),
  );
}
