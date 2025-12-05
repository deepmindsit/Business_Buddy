import 'package:businessbuddy/utils/exported_path.dart';

import '../../../../../utils/like_animation.dart';
import 'comment_bottomsheet.dart';

class FeedCard extends StatelessWidget {
  final dynamic data;
  final void Function()? onFollow;
  final void Function() onLike;
  FeedCard({super.key, this.data, this.onFollow, required this.onLike});

  final navController = getIt<NavigationController>();
  final _homeController = getIt<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.all(8.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: Colors.grey.shade100, width: 1),
      ),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
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
              spacing: 4.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: data['business_name'] ?? '',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  color: Colors.black,
                  maxLines: 1,
                  style: TextStyle(
                    height: 1,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    CustomText(
                      title: data['category'] ?? '',
                      fontSize: 10.sp,
                      textAlign: TextAlign.start,
                      color: Colors.grey.shade600,
                      maxLines: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Container(
                        width: 3.r,
                        height: 3.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    _buildTimeDisplay(),
                  ],
                ),
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
      final isFollowing = data['is_followed'] == true;
      return isLoading
          ? LoadingWidget(color: primaryColor, size: 20.r)
          : GestureDetector(
              onTap: onFollow,
              child: Container(
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  gradient: isFollowing
                      ? null
                      : LinearGradient(
                          colors: [
                            primaryColor,
                            primaryColor.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isFollowing
                        ? Colors.grey.shade300
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  spacing: 4.w,
                  children: [
                    Icon(
                      isFollowing ? Icons.check : Icons.add,
                      size: 14.sp,
                      color: isFollowing ? Colors.grey.shade600 : Colors.white,
                    ),
                    CustomText(
                      title: isFollowing ? 'Following' : 'Follow',
                      fontSize: 12.sp,
                      color: isFollowing ? Colors.grey.shade700 : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            );
    });
  }

  Widget _buildImageSection() {
    final image = data['image'] ?? '';
    // _homeController.detectImageRatio(image);
    return Obx(
      () => GestureDetector(
        onDoubleTap: () async {
          _homeController.isLikeAnimating.value = true;
          onLike();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 380.h),
                child: FadeInImage(
                  placeholder: const AssetImage(Images.defaultImage),
                  image: NetworkImage(image),
                  width: Get.width,
                  fit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Image.asset(
                        Images.defaultImage,
                        width: 150.w,
                        height: 150.h,
                      ),
                    );
                  },
                  fadeInDuration: const Duration(milliseconds: 500),
                ),

                // Image.network(
                //   image,
                //   fit: BoxFit.contain,
                //   width: Get.width,
                // ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _homeController.isLikeAnimating.value ? 1 : 0,
              child: LikeAnimation(
                isAnimating: _homeController.isLikeAnimating.value,
                duration: const Duration(milliseconds: 400),
                onEnd: () {
                  _homeController.isLikeAnimating.value = false;
                },
                child: Icon(
                  data['is_liked'] == true ? Icons.favorite : Icons.favorite,
                  color: data['is_liked'] == true ? lightGrey : Colors.red,
                  size: 40.r,
                ),
              ),
            ),
          ],
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
                  : _buildEngagementButton(
                      icon: Icons.favorite_border,
                      activeIcon: Icons.favorite,
                      isActive: data['is_liked'] == true,
                      count: data['likes_count']?.toString() ?? '0',
                      onTap: onLike,
                      activeColor: Colors.red,
                    );
            }),

            SizedBox(width: 16.w),

            _buildEngagementButton(
              icon: HugeIcons.strokeRoundedMessage02,
              activeIcon: Icons.comment,
              isActive: false,
              count: data['comments_count']?.toString() ?? '0',
              onTap: _handleComment,
              isComment: true,
            ),

            //
            // Obx(() {
            //   bool isLoading = false;
            //   if (data['is_liked'] == true) {
            //     isLoading =
            //         getIt<FeedsController>().likeLoadingMap[data['liked_id']
            //             .toString()] ==
            //         true;
            //   } else {
            //     isLoading =
            //         getIt<FeedsController>().likeLoadingMap[data['business_id']
            //             .toString()] ==
            //         true;
            //   }
            //
            //   return isLoading
            //       ? LoadingWidget(color: primaryColor, size: 20.r)
            //       : _buildEngagementItem(
            //           icon: HugeIcons.strokeRoundedFavourite,
            //           count: data['likes_count'].toString(),
            //           onTap: onLike,
            //           isLike: true,
            //         );
            // }),
            // SizedBox(width: 12.w),
            // _buildEngagementItem(
            //   icon: HugeIcons.strokeRoundedMessage02,
            //   count: data['comments_count'].toString(),
            //   onTap: () => _handleComment(),
            // ),
          ],
        ),

        // Offers Button
        // _buildOffersButton(),
      ],
    );
  }

  Widget _buildEngagementButton({
    required dynamic icon,
    required IconData activeIcon,
    required bool isActive,
    required String count,
    required VoidCallback onTap,
    Color? activeColor,
    bool isComment = false,
  }) {
    final color = isActive
        ? (activeColor ?? primaryColor)
        : Colors.grey.shade600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isComment
                  ? HugeIcon(
                      icon: icon,
                      color: Colors.grey.shade700,
                      size: 18.sp,
                    )
                  : Icon(
                      isActive ? activeIcon : icon,
                      key: ValueKey(isActive),
                      size: 18.sp,
                      color: color,
                    ),
            ),
            if (count.isNotEmpty) ...[
              SizedBox(width: 6.w),
              Text(
                _formatCount(int.tryParse(count) ?? 0),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  // Widget _buildEngagementItem({
  //   required var icon,
  //   required String count,
  //   required VoidCallback onTap,
  //   bool isLike = false,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
  //       decoration: BoxDecoration(
  //         color: Colors.grey.shade50,
  //         borderRadius: BorderRadius.circular(8.r),
  //       ),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           isLike && data['is_liked'] == true
  //               ? Icon(Icons.favorite, color: Colors.red, size: 18.sp)
  //               : HugeIcon(
  //                   icon: icon,
  //                   color: Colors.grey.shade700,
  //                   size: 18.sp,
  //                 ),
  //           SizedBox(width: 6.w),
  //           CustomText(
  //             title: count,
  //             fontSize: 12.sp,
  //             color: Colors.grey.shade700,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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

  Widget _buildContentSection() {
    final content = data['details'] ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: content,
          fontSize: 14.sp,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 14.sp, height: 1.5),
          maxLines: 2,
        ),

        // Read more button for long content
        if (content.length > 150)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: GestureDetector(
              onTap: () => expandContent(content),
              child: Text(
                'Read more',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _handleComment() {
    if (!getIt<DemoService>().isDemo) {
      ToastUtils.showLoginToast();
      return;
    }
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
