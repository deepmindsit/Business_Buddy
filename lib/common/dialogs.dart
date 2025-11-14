import 'dart:io';
import 'package:businessbuddy/utils/exported_path.dart';
import 'package:flutter/cupertino.dart';

class AllDialogs {
  void noInternetDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: const Text(
            'No Internet Connection',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Images.noInternet, width: Get.height * 0.25.w),
              const SizedBox(height: 12),
              const Text('Please check your internet connection.'),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final isConnected =
                    await InternetConnectionChecker.instance.hasConnection;
                if (isConnected) {
                  if (Get.isDialogOpen ?? false) Get.back();
                  // await checkMaintenance();
                } else {
                  // Optionally show a toast/snackbar
                }
              },
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void changeNumber(String number) {
    if (Platform.isIOS) {
      // iOS style dialog
      showCupertinoDialog(
        context: Get.context!,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text('Change Number'),
          content: Text('Are you sure you want to change\n+91 $number'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx),
              isDestructiveAction: true,
              child: const Text('No'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                getIt<OnboardingController>().numberController.clear();
                Get.offAllNamed(Routes.login);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    } else {
      // Android style dialog
      Get.dialog(
        AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content: Text('Are you sure you want to change\n+91 $number'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('No', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                getIt<OnboardingController>().numberController.clear();
                Get.offAllNamed(Routes.login);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
  }

  void offerDialog(dynamic offers) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height * 0.7.h),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: 'Latest Local Offers Just for You!',
                      fontSize: 18.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, color: Colors.grey, size: 20.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                const Divider(),
                // Offers list

                // Offers list
                offers.isEmpty
                    ? Center(
                        child: CustomText(
                          title: 'No offers available',
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      )
                    : Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: 8.h),
                          itemCount: offers.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final offer = offers[index];
                            return _buildOfferTile(offer);
                          },
                        ),
                      ),
                // SizedBox(height: 8.h),
                //
                // _buildOfferTile(),
                // SizedBox(height: 12.h),
                // _buildOfferTile(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void requestDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: 'Request',
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, color: Colors.grey, size: 20.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                const Divider(),
                // Offers list
                SizedBox(height: 8.h),
                buildRequestCard(
                  name: 'Ramesh Patil',
                  title:
                      'Requirement Title: Looking for Food Ingredient Supplier',
                  message:
                      'You’ve received a new collaboration request from Restaurant.',
                  date: '30 Oct 2025 • 10:42 AM',
                  buttonText: 'Accept Request',
                ),
                SizedBox(height: 12.h),

                // Request Card 2
                buildRequestCard(
                  name: 'Neha Deshmukh',
                  message:
                      'You’ve received a new chat request from Pizza Point Café.',
                  date: '30 Oct 2025 • 10:42 AM',
                  buttonText: 'Accept Chat',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showConfirmationDialog(
    String title,
    String message, {
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      Dialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 50.sp,
                color: Colors.redAccent,
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: onConfirm,
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRequestCard({
    required String name,
    String? title,
    required String message,
    required String date,
    required String buttonText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 22.r,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          SizedBox(width: 10.w),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                    ),
                  ],
                ),
                if (title != null) ...[
                  SizedBox(height: 3.h),
                  Text(
                    title,
                    style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                  ),
                ],
                SizedBox(height: 4.h),
                Text(
                  message,
                  style: TextStyle(fontSize: 11.sp, color: Colors.black87),
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(color: Colors.red, fontSize: 12.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferTile(dynamic offer) {
    return OfferTile(
      point: offer['highlight_points'] ?? [],
      imageUrl: offer['image'] ?? '',
      restaurantName: offer['business_name'] ?? '',
      offerTitle: offer['details'] ?? '',
      dateRange: '${offer['start_date'] ?? ''} to ${offer['end_date'] ?? ''}  ',
    );
  }
}

class OfferTile extends StatelessWidget {
  final String imageUrl;
  final String restaurantName;
  final String offerTitle;
  final String dateRange;
  final List point;

  const OfferTile({
    super.key,
    required this.imageUrl,
    required this.restaurantName,
    required this.offerTitle,
    required this.dateRange,
    required this.point,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imageUrl,
              height: 60.h,
              width: 60.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.w),

          // Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurantName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  offerTitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      dateRange,
                      style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: point.map((v) {
                    return buildBulletPoint(text: v);
                  }).toList(),
                ),

                // _buildBulletPoint(text: 'No minimum order'),
                // _buildBulletPoint(text: 'Extra cheese free on weekend orders'),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
Widget buildBulletPoint({required String text}) {
  return Row(
    children: [
      // Bullet point
      Container(
        margin: EdgeInsets.only(right: 8.w),
        width: 8.r,
        height: 8.r,
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
      ),
      // Text
      Expanded(
        child: CustomText(
          title: text,
          fontSize: 12.sp,
          color: Colors.grey.shade700,
          textAlign: TextAlign.start,
        ),
      ),
    ],
  );
}