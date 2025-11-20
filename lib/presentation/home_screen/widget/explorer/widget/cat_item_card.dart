import 'package:businessbuddy/utils/exported_path.dart';

class CatItemCard extends StatelessWidget {
  final String name;
  final String location;
  final String category;
  final String rating;
  final String reviewCount;
  final String offerText;
  final String phoneNumber;
  final String distance;
  final String imagePath;
  final String latitude;
  final String longitude;
  final List offers;
  final VoidCallback? onCall;
  final VoidCallback? onFollow;
  final VoidCallback? onTap;

  const CatItemCard({
    super.key,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.offers,
    required this.location,
    required this.category,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.offerText,
    required this.phoneNumber,
    this.imagePath = Images.hotelImg,
    this.onCall,
    this.onFollow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          spacing: 12.h,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                SizedBox(width: 4.w),
                _buildContent(),
              ],
            ),

            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          // color: lightGrey,
          border: Border.all(color: lightGrey),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: FadeInImage(
          placeholder: const AssetImage(Images.defaultImage),
          image: NetworkImage(imagePath),
          width: 80.w,
          height: 80.h,
          imageErrorBuilder: (context, error, stackTrace) {
            return Container(
              width: 80.w,
              height: 80.h,
              padding: EdgeInsets.all(24.w),
              color: lightGrey,
              child: Image.asset(Images.defaultImage, fit: BoxFit.contain),
            );
          },
          fit: BoxFit.cover,
          placeholderFit: BoxFit.contain,
          fadeInDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHeader(), _buildLocation(), _buildCategory()],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomText(
            title: name,
            fontSize: 16.sp,
            textAlign: TextAlign.start,
            maxLines: 2,
            style: TextStyle(
              height: 1.2,
              fontSize: 16.sp,
              color: primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        _buildRating(),
      ],
    );
  }

  Widget _buildRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.white, size: 14.sp),
              SizedBox(width: 4.w),
              CustomText(
                title: rating,
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        CustomText(
          title: 'By $reviewCount',
          fontSize: 10.sp,
          color: textLightGrey,
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, color: textLightGrey, size: 14.sp),
        SizedBox(width: 4.w),
        Expanded(
          child: CustomText(
            title: '$location  | $distance Km',
            textAlign: TextAlign.start,
            fontSize: 12.sp,
            color: textLightGrey,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildCategory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: lightRed.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: lightRed.withValues(alpha: 0.3)),
          ),
          child: CustomText(
            title: category,
            fontSize: 12.sp,
            color: textLightGrey,
          ),
        ),
        GestureDetector(
          onTap: () {
            if (!getIt<DemoService>().isDemo) {
              ToastUtils.showLoginToast();
              return;
            }
            openMap(double.parse(latitude), double.parse(longitude));
          },
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedLocation05,
            color: primaryColor,
            // size: 20.sp,
          ),
        ),
      ],
    );
  }

  // Widget _buildOffer() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Expanded(
  //         flex: 2,
  //         child: Container(
  //           padding: EdgeInsets.all(6.w),
  //           decoration: BoxDecoration(
  //             color: primaryBlueColor.withValues(alpha: 0.02),
  //             borderRadius: BorderRadius.circular(8.r),
  //             border: Border.all(
  //               color: primaryBlueColor.withValues(alpha: 0.1),
  //             ),
  //           ),
  //           child: Row(
  //             spacing: 4.w,
  //             children: [
  //               HugeIcon(
  //                 icon: HugeIcons.strokeRoundedDiscount,
  //                 color: primaryBlueColor,
  //                 size: 16.sp,
  //               ),
  //               // SizedBox(width: 8.w),
  //               Expanded(
  //                 child: CustomText(
  //                   title: offerText,
  //                   fontSize: 12.sp,
  //                   color: textLightGrey,
  //                   maxLines: 1,
  //                 ),
  //               ),
  //               // SizedBox(width: 8.w),
  //               GestureDetector(
  //                 onTap: () => AllDialogs().offerDialog(),
  //                 child: CustomText(
  //                   title: '...See offer',
  //                   fontSize: 12.sp,
  //                   color: primaryColor,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildActionButton(
            icon: HugeIcons.strokeRoundedCall02,
            text: 'Call',
            onPressed: onCall,
            backgroundColor: Colors.transparent,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          flex: 2,
          child: _buildActionButton(
            icon: HugeIcons.strokeRoundedUserAdd02,
            text: 'Follow',
            onPressed: onFollow,
            backgroundColor: Colors.transparent,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          flex: 3,
          child: _buildActionButton(
            icon: HugeIcons.strokeRoundedDiscount,
            text: offerText,
            onPressed: () => AllDialogs().offerDialog(offers),
            backgroundColor: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required var icon,
    required String text,
    required VoidCallback? onPressed,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: icon,
              color: backgroundColor == primaryColor
                  ? Colors.white
                  : primaryColor,
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            CustomText(
              title: text,
              fontSize: 12.sp,
              color: backgroundColor == primaryColor
                  ? Colors.white
                  : primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

// Extension for formatting review counts
extension NumberFormatting on int {
  String formatCount() {
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}k';
    }
    return toString();
  }
}

// import 'package:businessbuddy/utils/exported_path.dart';
//
// class CatItemCard extends StatelessWidget {
//   const CatItemCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: lightGrey,
//         borderRadius: BorderRadius.circular(10.r),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         spacing: 12.w,
//         children: [_buildImage(), _buildNameNRating()],
//       ),
//     );
//   }
//
//   Widget _buildImage() {
//     return FadeInImage(
//       placeholder: const AssetImage(Images.logo),
//       image: const AssetImage(Images.hotelImg),
//       width: 100.w,
//       height: 100.h,
//       imageErrorBuilder: (context, error, stackTrace) {
//         return Image.asset(
//           Images.logo,
//           width: 100.w,
//           height: 100.h,
//           fit: BoxFit.contain,
//         );
//       },
//       fit: BoxFit.contain,
//       placeholderFit: BoxFit.contain,
//       fadeInDuration: const Duration(milliseconds: 300),
//     );
//   }
//
//   Widget _buildNameNRating() {
//     return Expanded(
//       child: Column(
//         spacing: 8,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: CustomText(
//                   title: 'Hotel Jyoti Family Restaurant',
//                   fontSize: 16.sp,
//                   textAlign: TextAlign.start,
//                   color: primaryColor,
//                   maxLines: 2,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 6.w),
//                     decoration: BoxDecoration(
//                       color: primaryColor,
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.star, color: Colors.white, size: 14.sp),
//                         CustomText(
//                           title: '4.5',
//                           fontSize: 12.sp,
//                           color: Colors.white,
//                         ),
//                       ],
//                     ),
//                   ),
//                   CustomText(
//                     title: 'By 630+',
//                     fontSize: 10.sp,
//                     color: textLightGrey,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Icon(Icons.location_on, color: textLightGrey, size: 14.sp),
//               CustomText(
//                 title: 'Hinjewadi Phase 1',
//                 fontSize: 14.sp,
//                 color: textLightGrey,
//               ),
//             ],
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 6.w),
//             decoration: BoxDecoration(
//               color: lightRed,
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: CustomText(
//               title: 'Restaurant',
//               fontSize: 12.sp,
//               color: textLightGrey,
//             ),
//           ),
//           Row(
//             children: [
//               HugeIcon(
//                 icon: HugeIcons.strokeRoundedDiscount,
//                 color: primaryBlueColor,
//                 size: 14.sp,
//               ),
//               Row(
//                 spacing: 4.w,
//                 children: [
//                   CustomText(
//                     title: 'Flat ₹80 OFF above ₹199',
//                     fontSize: 12.sp,
//                     color: textLightGrey,
//                   ),
//                   CustomText(
//                     title: '...See offer',
//                     fontSize: 12.sp,
//                     color: primaryColor,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Row(
//             spacing: 8.w,
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
//                 decoration: BoxDecoration(
//                   color: primaryColor,
//                   borderRadius: BorderRadius.circular(4.r),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.call, color: Colors.white, size: 14.sp),
//                     CustomText(
//                       title: '+91XXXXXXXXXX',
//                       fontSize: 12.sp,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
//                 decoration: BoxDecoration(
//                   color: primaryColor,
//                   borderRadius: BorderRadius.circular(4.r),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.person_add_alt_1_rounded,
//                       color: Colors.white,
//                       size: 14.sp,
//                     ),
//                     CustomText(
//                       title: 'Follow',
//                       fontSize: 12.sp,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
