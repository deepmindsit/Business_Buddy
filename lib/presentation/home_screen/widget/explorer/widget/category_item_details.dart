import 'package:businessbuddy/utils/utils.dart';

import '../../../../../utils/exported_path.dart';

class CategoryDetailPage extends StatefulWidget {
  final String title;
  final String businessId;
  const CategoryDetailPage({
    super.key,
    required this.title,
    required this.businessId,
  });

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  final controller = getIt<ExplorerController>();
  final navController = getIt<NavigationController>();

  @override
  void initState() {
    controller.getBusinessDetails(widget.businessId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const Divider(),
        Expanded(
          child: Obx(
            () => controller.isDetailsLoading.isTrue
                ? LoadingWidget(color: primaryColor)
                : controller.businessDetails.isEmpty
                ? Center(
                    child: CustomText(
                      title: 'No Data Found',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 20.h, top: 0.h),
                    child: _buildBody(),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        spacing: 8,
        children: [
          GestureDetector(
            onTap: () => navController.goBack(),
            child: const Icon(Icons.arrow_back),
          ),
          CustomText(
            title: widget.title,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
    //   Container(
    //   color: Colors.white,
    //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    //   child: Row(
    //     children: [
    //       GestureDetector(
    //         onTap: () => navController.goBack(),
    //         child: Container(
    //           padding: EdgeInsets.all(8.w),
    //           decoration: BoxDecoration(
    //             color: Colors.grey.shade100,
    //             borderRadius: BorderRadius.circular(8.r),
    //           ),
    //           child: Icon(
    //             Icons.arrow_back_ios_rounded,
    //             size: 18.sp,
    //             color: Colors.grey.shade700,
    //           ),
    //         ),
    //       ),
    //       SizedBox(width: 12.w),
    //       Expanded(
    //         child: CustomText(
    //           title: widget.title,
    //           textAlign: TextAlign.start,
    //           fontSize: 18.sp,
    //           fontWeight: FontWeight.w700,
    //           color: Colors.black87,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(),
          SizedBox(height: 18.h),
          _buildHotelDetails(),
          SizedBox(height: 12.h),
          _buildActionButtons(),
          Divider(),
          _buildAboutSection(),
          _buildPostAndOffers(),
          Divider(),
          _buildReviewsSection(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        _buildMainImage(),
        SizedBox(height: 12.h),
        _buildImageGallery(),
      ],
    );
  }

  Widget _buildMainImage() {
    final image = controller.businessDetails['image'];
    return Container(
      // padding: EdgeInsets.all(2),
      // clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Stack(
        // clipBehavior: Clip.hardEdge,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: FadeInImage(
              placeholder: const AssetImage(Images.defaultImage),
              image: NetworkImage(image),
              width: double.infinity,
              height: 180.h,
              imageErrorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 180.h,
                  padding: EdgeInsets.all(32.w),
                  child: Image.asset(Images.defaultImage, fit: BoxFit.cover),
                );
              },
              fit: BoxFit.cover,
              placeholderFit: BoxFit.contain,
              fadeInDuration: const Duration(milliseconds: 500),
            ),
          ),
          Positioned(top: 10, right: 10, child: _buildCategoryChip()),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = controller.businessDetails['attachments'];
    return SizedBox(
      height: 60.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Add image preview functionality
            },
            child: Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade200, width: 1),
                image: DecorationImage(
                  image: NetworkImage(images[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHotelDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: widget.title,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                  ),
                  SizedBox(height: 8.h),
                  _buildRatingSection(),
                  SizedBox(height: 8.h),
                  _buildFollowCount(),
                  SizedBox(height: 8.h),
                  _buildLocationSection(),
                  // SizedBox(height: 8.h),
                  // _buildCategoryChip(),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            _buildOfferCard(),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: Colors.white, size: 14.sp),
              SizedBox(width: 4.w),
              CustomText(
                title: '4.9',
                fontSize: 12.sp,
                textAlign: TextAlign.start,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        CustomText(
          title: '(500+ reviews)',
          fontSize: 12.sp,
          color: Colors.grey.shade600,
        ),
      ],
    );
  }

  Widget _buildFollowCount() {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            spacing: 8.w,
            mainAxisSize: MainAxisSize.min,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedUserAdd02,
                size: 16.sp,
                color: Colors.grey,
              ),
              CustomText(
                title: '1200+ Followers',
                fontSize: 12.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          color: Colors.grey.shade600,
          size: 16.sp,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: CustomText(
            title:
                '${controller.businessDetails['address'] ?? ''} | ${controller.businessDetails['distance']?.toString() ?? ''} km',
            fontSize: 14.sp,
            textAlign: TextAlign.start,
            color: Colors.grey.shade700,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip() {
    final category = controller.businessDetails['category'];
    if (category == null) return SizedBox();
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: CustomText(
            title: controller.businessDetails['category'] ?? '',
            fontSize: 12.sp,
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard() {
    final offerCount =
        controller.businessDetails['offers_count']?.toString() ?? '';
    final offer = controller.businessDetails['offers'] ?? [];
    if (offer.isEmpty) return SizedBox();
    return GestureDetector(
      onTap: () {
        AllDialogs().offerDialog(offer);
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 4.h),
                HugeIcon(
                  icon: HugeIcons.strokeRoundedDiscount,
                  color: primaryColor,
                  size: 20.sp,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  title: 'See Offer',
                  fontSize: 10.sp,
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Positioned(
            top: -15,
            child: Wrap(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: lightGrey,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    spacing: 2.w,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedDiscount,
                        size: 16.sp,
                        color: primaryColor,
                      ),
                      CustomText(
                        title: '$offerCount Offers',
                        fontSize: 12.sp,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      spacing: 12.w,
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.call_outlined,
            text: '+91XXXXXXXXXX',
            onPressed: () => _handleCall(),
            backgroundColor: primaryColor,
            isPrimary: true,
          ),
        ),
        Expanded(
          child: _buildActionButton(
            icon: Icons.person_add_outlined,
            text: 'Follow',
            onPressed: () => _handleFollow(),
            backgroundColor: Colors.transparent,
            isPrimary: false,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: primaryColor,
          border: Border.all(
            color: isPrimary ? primaryColor : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            CustomText(
              title: text,
              fontSize: 13.sp,
              color: Colors.white,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: 'About',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        CustomText(
          title: controller.businessDetails['about_business'] ?? '',
          fontSize: 14.sp,
          maxLines: 20,
          textAlign: TextAlign.start,
          color: Colors.grey.shade700,
        ),
        SizedBox(height: 16.h),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildPostAndOffers() {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Tab Bar ---
            TabBar(
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Post'),
                Tab(text: 'Offer'),
              ],
            ),

            // --- Tab Content ---
            SizedBox(
              height: Get.height * 0.45.h,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(), // prevents
                children: [
                  buildGridImages(controller.businessDetails['posts']),
                  buildGridImages(controller.businessDetails['offers']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          title: CustomText(
            title: 'Reviews & Ratings',
            fontSize: 16.sp,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          childrenPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          children: [
            buildReviewTile(
              userName: 'Mandar',
              review:
                  'At Hotel Jyoti Family Restaurant, I was delighted by the rich flavors and aromatic dishes. Each bite of their signature biryani was a culinary delight, bursting with spices.',
              rating: 5,
            ),
            SizedBox(height: 16.h),
            const Divider(height: 1),
            SizedBox(height: 16.h),
            buildReviewTile(
              userName: 'Danish',
              review:
                  'At Hotel Jyoti Family Restaurant, I was delighted by the rich flavors and aromatic dishes. Each bite of their signature biryani was a culinary delight, bursting with spices.',
              rating: 5,
            ),
            SizedBox(height: 8.h),
            _buildViewAllReviews(),
          ],
        ),
        Center(
          child: GestureDetector(
            onTap: () => _addReview(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: primaryColor, size: 16.sp),
                  SizedBox(width: 4.w),
                  CustomText(
                    title: 'Add Review',
                    fontSize: 12.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewAllReviews() {
    return Center(
      child: TextButton(
        onPressed: () {
          // Navigate to all reviews page
        },
        child: CustomText(
          title: 'View All Reviews',
          fontSize: 14.sp,
          color: primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _handleCall() {
    makePhoneCall(controller.businessDetails['mobile_number'] ?? '');
  }

  void _handleFollow() {
    // Implement follow functionality
  }

  void _addReview() {
    // Implement add review functionality
  }
}

// import '../utils/exported_path.dart';
//
// class CategoryDetailPage extends StatelessWidget {
//   final String title;
//   CategoryDetailPage({super.key, required this.title});
//   final List<String> imageList = [
//     Images.hotelImg,
//     Images.hotelImg,
//     Images.hotelImg,
//     Images.hotelImg,
//   ];
//   @override
//   Widget build(BuildContext context) {
//     final navController = getIt<NavigationController>();
//
//     return SingleChildScrollView(
//       child: Column(children: [_buildHeader(navController), _buildBody()]),
//     );
//   }
//
//   Widget _buildHeader(NavigationController navController) {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//       child: Row(
//         spacing: 8.h,
//         children: [
//           GestureDetector(
//             onTap: () => navController.goBack(),
//             child: const Icon(Icons.arrow_back),
//           ),
//           CustomText(
//             title: title,
//             fontSize: 18.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBody() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 12.h),
//       child: Column(
//         spacing: 8.h,
//         children: [
//           _buildImage(),
//           _buildImageList(),
//           _buildHotelDetails(),
//           _buildActionButtons(),
//           _buildAbout(),
//           _buildReview(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildImage() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12.r),
//       child: FadeInImage(
//         placeholder: const AssetImage(Images.logo),
//         image: AssetImage(Images.hotelImgLarge),
//         width: Get.width.w,
//         height: 180.h,
//         imageErrorBuilder: (context, error, stackTrace) {
//           return Container(
//             width: Get.width.w,
//             height: 180.h,
//             padding: EdgeInsets.all(24.w),
//             color: lightGrey,
//             child: Image.asset(Images.logo, fit: BoxFit.contain),
//           );
//         },
//         fit: BoxFit.cover,
//         placeholderFit: BoxFit.contain,
//         fadeInDuration: const Duration(milliseconds: 300),
//       ),
//     );
//   }
//
//   Widget _buildImageList() {
//     return SizedBox(
//       height: 55.h,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: imageList.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 8),
//         itemBuilder: (context, index) {
//           return Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey.shade300),
//               image: DecorationImage(
//                 image: AssetImage(imageList[index]),
//                 fit: BoxFit.contain,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildHotelDetails() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             spacing: 8.h,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomText(
//                 title: title,
//                 fontSize: 16.sp,
//                 textAlign: TextAlign.start,
//                 maxLines: 2,
//                 style: TextStyle(
//                   height: 1,
//                   fontSize: 16.sp,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 4.w,
//                       vertical: 2.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: primaryColor,
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.star, color: Colors.white, size: 14.sp),
//                         SizedBox(width: 4.w),
//                         CustomText(
//                           title: '4.9',
//                           fontSize: 14.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 8.h),
//                   CustomText(
//                     title: 'By 500',
//                     fontSize: 14.sp,
//                     color: textLightGrey,
//                   ),
//                 ],
//               ),
//               _buildLocation(),
//               _buildCategory(),
//             ],
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 20.w),
//             decoration: BoxDecoration(
//               // color: lightRed.withValues(alpha: 0.5),
//               borderRadius: BorderRadius.circular(6.r),
//               border: Border.all(width: 0.5, color: primaryColor),
//             ),
//             child: Column(
//               children: [
//                 HugeIcon(
//                   icon: HugeIcons.strokeRoundedDiscount,
//                   color: primaryBlueColor,
//                   size: 16.sp,
//                 ),
//                 CustomText(
//                   title: 'See offer',
//                   fontSize: 12.sp,
//                   color: primaryColor,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLocation() {
//     return Row(
//       children: [
//         Icon(Icons.location_on_outlined, color: textLightGrey, size: 14.sp),
//         SizedBox(width: 4.w),
//         CustomText(
//           title: 'Kandivali West, Mumbai',
//           textAlign: TextAlign.start,
//           fontSize: 12.sp,
//           color: textLightGrey,
//           maxLines: 1,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCategory() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8.w),
//       decoration: BoxDecoration(
//         color: lightRed.withValues(alpha: 0.5),
//         borderRadius: BorderRadius.circular(6.r),
//         border: Border.all(color: lightRed.withValues(alpha: 0.3)),
//       ),
//       child: CustomText(
//         title: 'Restaurant',
//         fontSize: 12.sp,
//         color: textLightGrey,
//       ),
//     );
//   }
//
//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildActionButton(
//             icon: Icons.call_outlined,
//             text: 'Call',
//             onPressed: () {},
//             backgroundColor: primaryColor,
//           ),
//         ),
//         SizedBox(width: 8.w),
//         Expanded(
//           child: _buildActionButton(
//             icon: Icons.person_add_outlined,
//             text: 'Follow',
//             onPressed: () {},
//             backgroundColor: primaryColor,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required String text,
//     required VoidCallback? onPressed,
//     required Color backgroundColor,
//   }) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//         decoration: BoxDecoration(
//           // color: backgroundColor,
//           border: Border.all(color: Colors.red),
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: primaryColor, size: 16.sp),
//             SizedBox(width: 6.w),
//             CustomText(
//               title: text,
//               fontSize: 12.sp,
//               color: primaryColor,
//               fontWeight: FontWeight.w600,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAbout() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Divider(),
//         CustomText(
//           title: 'About',
//           fontSize: 18.sp,
//           fontWeight: FontWeight.bold,
//         ),
//         CustomText(
//           title:
//               'Chinese, Punjabi, Mughlai, Sea Food, North Indian, Malwani, Maharashtrian',
//           fontSize: 14.sp,
//           maxLines: 30,
//           textAlign: TextAlign.start,
//         ),
//         Divider(),
//       ],
//     );
//   }
//
//   Widget _buildReview() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             CustomText(
//               title: 'Reviews & Ratings',
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//             ),
//             CustomText(
//               title: 'Add Review',
//               fontSize: 18.sp,
//               color: primaryColor,
//               fontWeight: FontWeight.bold,
//             ),
//           ],
//         ),
//         ListTile(
//           leading: CircleAvatar(backgroundImage: AssetImage(Images.hotelImg)),
//           title: CustomText(
//             title: 'Mandar',
//             fontSize: 14.sp,
//             maxLines: 2,
//             textAlign: TextAlign.start,
//             fontWeight: FontWeight.bold,
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomText(
//                 title:
//                     'At Hotel Jyoti Family Restaurant, I was delighted by the rich flavors and aromatic dishes. Each bite of their signature biryani was a culinary delight, bursting with spices.',
//                 fontSize: 12.sp,
//                 textAlign: TextAlign.start,
//                 maxLines: 20,
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Divider(),
//         ListTile(
//           leading: CircleAvatar(backgroundImage: AssetImage(Images.hotelImg)),
//           title: CustomText(
//             title: 'DANISH',
//             fontSize: 14.sp,
//             maxLines: 2,
//             textAlign: TextAlign.start,
//             fontWeight: FontWeight.bold,
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomText(
//                 title:
//                     'At Hotel Jyoti Family Restaurant, I was delighted by the rich flavors and aromatic dishes. Each bite of their signature biryani was a culinary delight, bursting with spices.',
//                 fontSize: 12.sp,
//                 textAlign: TextAlign.start,
//                 maxLines: 20,
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                   Icon(Icons.star, color: Colors.amberAccent, size: 14.w),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
