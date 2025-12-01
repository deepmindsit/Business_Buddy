import 'package:businessbuddy/utils/exported_path.dart';

import 'comment_bottomsheet.dart';

class FeedCard extends StatelessWidget {
  final dynamic data;
  final void Function()? onFollow;
  final void Function() onLike;
  FeedCard({super.key, this.data, this.onFollow, required this.onLike});

  final navController = getIt<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      elevation: 2,
      // shadowColor: lightGrey,
      margin: EdgeInsets.all(8.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(),
            // SizedBox(height: 16.h),
            _buildContentSection(),
            // Image Section
            _buildImageSection(),

            _buildEngagementSection(),
            // _buildTimeDisplay(),

            // Content Section
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final image = data['business_profile_image'] ?? '';
    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: Colors.grey.shade100,
          child: ClipOval(
            child: FadeInImage(
              placeholder: const AssetImage(Images.defaultImage),
              image: NetworkImage(image),
              width: double.infinity,
              height: 100.w,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Image.asset(
                    Images.defaultImage,
                    width: 100.w,
                    height: 100.w,
                  ),
                );
              },
              fadeInDuration: const Duration(milliseconds: 500),
            ),
          ),
          // backgroundImage: AssetImage(Images.hotelImg),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: GestureDetector(
            onTap: () {
              navController.openSubPage(
                CategoryDetailPage(
                  title: data['business_name'] ?? '',
                  businessId: data['business_id']?.toString() ?? '',
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: data['business_name'] ?? '',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  color: Colors.black87,
                  maxLines: 1,
                  style: TextStyle(
                    height: 1,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                CustomText(
                  title: data['category'] ?? '',
                  fontSize: 10.sp,
                  textAlign: TextAlign.start,
                  color: Colors.grey.shade600,
                  maxLines: 1,
                  style: TextStyle(
                    // height: 1,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                _buildTimeDisplay(),
                // CustomText(
                //   title: getTimeAgo(data['created_at'] ?? ''),
                //   fontSize: 10.sp,
                //   textAlign: TextAlign.start,
                //   color: Colors.grey.shade600,
                //   maxLines: 1,
                //   style: TextStyle(
                //     height: 1,
                //     fontSize: 10.sp,
                //     color: Colors.grey.shade600,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        _buildFollowButton(),
      ],
    );
  }

  Widget _buildFollowButton() {
    if (data['self_business'] == true) return SizedBox();

    return Obx(() {
      bool isLoading = false;
      if (data['is_followed'] == true) {
        isLoading =
            getIt<FeedsController>().followingLoadingMap[data['follow_id']
                .toString()] ==
            true;
      } else {
        isLoading =
            getIt<FeedsController>().followingLoadingMap[data['business_id']
                .toString()] ==
            true;
      }

      return isLoading
          ? LoadingWidget(color: primaryColor)
          : GestureDetector(
              onTap: onFollow,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CustomText(
                  title: data['is_followed'] == true ? 'Following' : 'Follow',
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
    });
  }

  Widget _buildImageSection() {
    final image = data['image'] ?? '';
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: AspectRatio(
          aspectRatio: 1.4,
          child: InstaLikeButton(
            image: NetworkImage(image),
            onChanged: onLike,
            iconSize: 80.r,
            icon: data['is_liked'] == true ? Icons.favorite : Icons.favorite,
            iconColor: data['is_liked'] == true ? lightGrey : Colors.red,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(milliseconds: 500),
            onImageError: (e, _) {
              return Center(
                child: Image.asset(
                  Images.defaultImage,
                  width: 150.w,
                  height: 150.w,
                ),
              );
            },
            imageBoxfit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildEngagementSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Likes and Comments
        Row(
          children: [
            Obx(() {
              bool isLoading = false;
              if (data['is_liked'] == true) {
                isLoading =
                    getIt<FeedsController>().likeLoadingMap[data['liked_id']
                        .toString()] ==
                    true;
              } else {
                isLoading =
                    getIt<FeedsController>().likeLoadingMap[data['business_id']
                        .toString()] ==
                    true;
              }

              return isLoading
                  ? LoadingWidget(color: primaryColor, size: 20.r)
                  : _buildEngagementItem(
                      icon: HugeIcons.strokeRoundedFavourite,
                      count: data['likes_count'].toString(),
                      onTap: onLike,
                      isLike: true,
                    );
            }),
            SizedBox(width: 12.w),
            _buildEngagementItem(
              icon: HugeIcons.strokeRoundedMessage02,
              count: data['comments_count'].toString(),
              onTap: () => _handleComment(),
            ),
          ],
        ),

        // Offers Button
        // _buildOffersButton(),
      ],
    );
  }

  Widget _buildEngagementItem({
    required var icon,
    required String count,
    required VoidCallback onTap,
    bool isLike = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLike && data['is_liked'] == true
                ? Icon(Icons.favorite, color: Colors.red, size: 18.sp)
                : HugeIcon(
                    icon: icon,
                    color: Colors.grey.shade700,
                    size: 18.sp,
                  ),
            SizedBox(width: 6.w),
            CustomText(
              title: count,
              fontSize: 12.sp,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    final createdAt = data['created_at'] ?? '';
    if (createdAt == null || createdAt.toString().isEmpty) {
      return SizedBox();
    }

    return CustomText(
      title: getTimeAgo(createdAt),
      fontSize: 10.sp,
      textAlign: TextAlign.start,
      color: Colors.grey.shade600,
      maxLines: 1,
    );
  }

  // Widget _buildOffersButton() {
  //   return GestureDetector(
  //     onTap: () {
  //       // Handle offers view
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
  //       decoration: BoxDecoration(
  //         color: primaryColor.withValues(alpha: 0.1),
  //         borderRadius: BorderRadius.circular(8.r),
  //         border: Border.all(
  //           color: primaryColor.withValues(alpha: 0.3),
  //           width: 1,
  //         ),
  //       ),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           HugeIcon(
  //             icon: HugeIcons.strokeRoundedDiscount,
  //             color: primaryColor,
  //             size: 16.sp,
  //           ),
  //           SizedBox(width: 6.w),
  //           CustomText(
  //             title: 'View Offers',
  //             fontSize: 12.sp,
  //             color: primaryColor,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildContentSection() {
    return CustomText(
      title: data['details'] ?? '',
      fontSize: 14.sp,
      textAlign: TextAlign.start,
      maxLines: 2,
    );

    //   CustomText(
    //   title: data['details'] ?? '',
    //   fontSize: 13.sp,
    //   color: Colors.grey.shade700,
    //   maxLines: 2,
    //   textAlign: TextAlign.start,
    // );
  }

  void _handleComment() {
    Get.bottomSheet(
      CommentsBottomSheet(postId: data['post_id']?.toString() ?? ''),
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.grey.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      ignoreSafeArea: false,
    );
    // Implement comment functionality
  }
}

// class FeedCard extends StatelessWidget {
//   const FeedCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           ListTile(
//             // tileColor: Colors.amber,
//             contentPadding: EdgeInsets.all(4.w),
//             leading: CircleAvatar(backgroundImage: AssetImage(Images.hotelImg)),
//             title: CustomText(
//               title: 'Deepminds Infotech Pvt. Ltd.',
//               fontSize: 16.sp,
//               maxLines: 2,
//               textAlign: TextAlign.start,
//               fontWeight: FontWeight.bold,
//             ),
//             subtitle: CustomText(
//               title: 'Information technology',
//               fontSize: 12.sp,
//               maxLines: 2,
//               textAlign: TextAlign.start,
//             ),
//             trailing: GestureDetector(
//               onTap: () {},
//               child: Container(
//                 padding: EdgeInsets.all(8.w),
//                 decoration: BoxDecoration(
//                   color: primaryColor,
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(
//                       Icons.person_add_outlined,
//                       color: Colors.white,
//                       size: 18.sp,
//                     ),
//                     SizedBox(width: 8.w),
//                     CustomText(
//                       title: 'Follow',
//                       fontSize: 14.sp,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           AspectRatio(
//             aspectRatio: 1,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(28.r),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: ClipRRect(
//                 clipBehavior: Clip.none,
//                 borderRadius: BorderRadius.circular(28.r),
//                 child: FadeInImage(
//                   placeholder: const AssetImage(Images.logo),
//                   image: AssetImage(Images.feedImg),
//                   width: double.infinity,
//                   height: 180.h,
//                   imageErrorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       width: double.infinity,
//                       height: 180.h,
//                       padding: EdgeInsets.all(32.w),
//                       child: Image.asset(
//                         Images.logo,
//                         fit: BoxFit.contain,
//                         // color: Colors.grey.shade400,
//                       ),
//                     );
//                   },
//                   fit: BoxFit.cover,
//                   placeholderFit: BoxFit.contain,
//                   fadeInDuration: const Duration(milliseconds: 500),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   spacing: 8.w,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         HugeIcon(
//                           icon: HugeIcons.strokeRoundedFavourite,
//                           color: Colors.black,
//                           size: 18.sp,
//                         ),
//                         SizedBox(width: 8.w),
//                         CustomText(
//                           title: '10k',
//                           fontSize: 14.sp,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         HugeIcon(
//                           icon: HugeIcons.strokeRoundedMessage02,
//                           color: Colors.black,
//                           size: 18.sp,
//                         ),
//                         SizedBox(width: 8.w),
//                         CustomText(
//                           title: '500',
//                           fontSize: 14.sp,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(4.w),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8.r),
//                     border: Border.all(color: primaryColor),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       HugeIcon(
//                         icon: HugeIcons.strokeRoundedDiscount,
//                         color: primaryColor,
//                         size: 20.sp,
//                       ),
//                       SizedBox(width: 4.h),
//                       CustomText(
//                         title: 'See Offers',
//                         fontSize: 10.sp,
//                         color: primaryColor,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           CustomText(
//             title: 'Boost Your Local Business with Business Buddy!',
//             fontSize: 14.sp,
//             textAlign: TextAlign.start,
//             maxLines: 2,
//             fontWeight: FontWeight.w500,
//           ),
//
//           CustomText(
//             title:
//                 'Share offers, promote products, and connect directly with nearby customers — all in one app.',
//             fontSize: 12.sp,
//             maxLines: 20,
//             textAlign: TextAlign.start,
//           ),
//         ],
//       ),
//     );
//   }
// }
