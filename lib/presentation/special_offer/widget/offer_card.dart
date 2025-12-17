import 'package:businessbuddy/utils/exported_path.dart';

class OfferCard extends StatelessWidget {
  final dynamic data;
  final void Function() onLike;
  OfferCard({super.key, this.data, required this.onLike});

  final navController = getIt<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          surfaceTintColor: Colors.white,
          color: Colors.white,
          clipBehavior: Clip.none,
          elevation: 2,
          margin: EdgeInsets.all(8.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(),

                // Image Section
                _buildImageSection(),

                // Content Section
                _buildContentSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedDiscountTag02,
            size: 12.sp,
            color: Colors.red,
          ),
          SizedBox(width: 4.w),
          Text(
            'Special Offer',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final image = data['business_profile_image'] ?? '';
    return Row(
      spacing: 4.w,
      children: [
        CircleAvatar(
          radius: 18.r,
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
        ),
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
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Container(
                        width: 3.r,
                        height: 3.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    ClipRect(child: _buildTypeBadge()),
                  ],
                ),
              ],
            ),
          ),
        ),
        _buildFollowButton(),
      ],
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
          ? LoadingWidget(color: primaryColor)
          : GestureDetector(
              onTap: () async {
                if (getIt<DemoService>().isDemo == false) {
                  ToastUtils.showLoginToast();
                  return;
                }
                if (data['is_followed'] == true) {
                  await getIt<FeedsController>().unfollowBusiness(
                    data['follow_id'].toString(),
                  );
                } else {
                  await getIt<FeedsController>().followBusiness(
                    data['business_id'].toString(),
                  );
                }
                data['is_followed'] = !data['is_followed'];
                await getIt<FeedsController>().getFeeds(showLoading: false);

                // Handle follow action
              },
              child: Container(
                padding: EdgeInsets.all(8.w),
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

    //   GestureDetector(
    //   onTap: () {
    //     if (!getIt<DemoService>().isDemo) {
    //       ToastUtils.showLoginToast();
    //       return;
    //     }
    //   },
    //   child: Container(
    //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    //     decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //         colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
    //         begin: Alignment.topLeft,
    //         end: Alignment.bottomRight,
    //       ),
    //       borderRadius: BorderRadius.circular(8.r),
    //       boxShadow: [
    //         BoxShadow(
    //           color: primaryColor.withValues(alpha: 0.3),
    //           blurRadius: 4,
    //           offset: const Offset(0, 2),
    //         ),
    //       ],
    //     ),
    //     child: CustomText(
    //       title: data['is_followed'] == true ? 'Following' : 'Follow',
    //       fontSize: 12.sp,
    //       color: Colors.white,
    //       fontWeight: FontWeight.w600,
    //     ),
    //   ),
    // );
  }

  Widget _buildImageSection() {
    final image = data['image'] ?? '';
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        // border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 380.h),
          child:
              // Image.network(image, fit: BoxFit.contain, width: Get.width),
              FadeInImage(
                placeholder: const AssetImage(Images.defaultImage),
                image: NetworkImage(image),
                width: double.infinity,
                fit: BoxFit.contain,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Image.asset(
                      Images.defaultImage,
                      width: 150.w,
                      height: 150.w,
                    ),
                  );
                },
                fadeInDuration: const Duration(milliseconds: 500),
              ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        CustomText(
          title: data['offer_name'] ?? '',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: primaryColor,
          textAlign: TextAlign.start,
          maxLines: 2,
        ),
        // SizedBox(height: 8.h),
        _offerDetails(),
        SizedBox(height: 8.h),
        // Date Section
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 16.r,
              color: Colors.grey.shade600,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: CustomText(
                title:
                    '${data['start_date'] ?? ''} to ${data['end_date'] ?? ''}',
                fontSize: 14.sp,
                color: Colors.grey.shade700,
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data['highlight_points'].map<Widget>((v) {
            return buildBulletPoint(text: v);
          }).toList(),
        ),
        _buildEngagementSection(),
      ],
    );
  }

  Widget _offerDetails() {
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

  Widget _buildEngagementSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Likes and Comments
        Row(
          children: [
            buildEngagementButton(
              icon: Icons.favorite_border,
              activeIcon: Icons.favorite,
              isActive: data['is_offer_liked'] == true,
              count: data['offer_likes_count']?.toString() ?? '0',
              onTap: onLike,
              activeColor: Colors.red,
            ),

            SizedBox(width: 16.w),

            buildEngagementButton(
              icon: HugeIcons.strokeRoundedMessage02,
              activeIcon: Icons.comment,
              isActive: false,
              count: data['offer_comments_count']?.toString() ?? '0',
              onTap: _handleComment,
              isComment: true,
            ),
          ],
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
      CommentsBottomSheet(postId: data['id']?.toString() ?? '', isPost: false),
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
