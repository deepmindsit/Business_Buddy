// import '../utils/exported_path.dart';
//
// class CustomMainHeader extends StatelessWidget {
//   final bool showBackButton;
//   final VoidCallback? onBackTap;
//   final TextEditingController searchController;
//
//   CustomMainHeader({
//     super.key,
//     this.showBackButton = true,
//     this.onBackTap,
//     required this.searchController,
//   });
//   final controller = getIt<NavigationController>();
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: Get.width,
//           padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 16.h),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [primaryColor.withValues(alpha: 0.5), Colors.transparent],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// 🔹 Top Row: Logo + Icons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Image.asset(Images.logo, width: Get.width * 0.4.w),
//                     Row(
//                       children: [
//                         _buildActionIcon(
//                           icon: HugeIcons.strokeRoundedNotification02,
//                           onTap: () => Get.toNamed(Routes.notificationList),
//                         ),
//                         _buildActionIcon(
//                           icon: HugeIcons.strokeRoundedUserStory,
//                           onTap: () => Get.toNamed(
//                             Routes.profile,
//                             arguments: {'user_id': 'self'},
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//
//                 /// 🔹 Location Label
//                 Obx(
//                   () => Row(
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         color: textLightGrey,
//                         size: 14.sp,
//                       ),
//                       CustomText(
//                         title: getIt<SearchNewController>().address.value,
//                         fontSize: 14.sp,
//                         color: textLightGrey,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       Icon(
//                         Icons.arrow_drop_down,
//                         color: textLightGrey,
//                         size: 14.sp,
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: 8.h),
//
//                 /// 🔹 Search Field
//                 Row(
//                   children: [
//                     Expanded(
//                       child: buildTextField(
//                         controller: searchController,
//                         hintText: 'Search Offer, Interest, etc.',
//                         prefixIcon: Icon(Icons.search, color: lightGrey),
//                         validator: (value) => value!.trim().isEmpty
//                             ? 'Search Offer, Interest, etc.'
//                             : null,
//                       ),
//                     ),
//                     _buildActionIcon(
//                       color: primaryColor,
//                       iconColor: Colors.white,
//                       icon: HugeIcons.strokeRoundedFilter,
//                       onTap: () {},
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         CustomTabBar(),
//       ],
//     );
//   }
//
//   /// 🔹 Common Action Icon Builder
//   Widget _buildActionIcon({
//     required var icon,
//     required VoidCallback onTap,
//     Color? color,
//     Color? iconColor,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.only(left: 8.w),
//         padding: EdgeInsets.all(8.w),
//         decoration: BoxDecoration(
//           color: color ?? lightGrey,
//           shape: BoxShape.circle,
//         ),
//         child: HugeIcon(
//           icon: icon,
//           color: iconColor ?? textLightGrey,
//           size: 20.sp,
//         ),
//       ),
//     );
//   }
// }
