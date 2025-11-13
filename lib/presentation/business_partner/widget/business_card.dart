import 'package:businessbuddy/utils/exported_path.dart';

class BusinessCard extends StatelessWidget {
  final String status;
  const BusinessCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Color(0xffF4F4F4),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 1.w,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLeftData(),
            // Action Section
            VerticalDivider(
              color: Colors.grey.shade300,
              thickness: 1,
              width: 1,
            ),
            // _buildRightData(),
            status == 'Requested'
                ? _buildRightDataRequested()
                : status == 'Approved'
                ? _buildRightAccepted()
                : _buildRightData(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftData() {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.h,
          children: [
            // Header Section
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(Images.hotelImg),
                  radius: 22.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomText(
                    title: 'Electronics Retail Store Expansion',
                    fontSize: 16.sp,
                    textAlign: TextAlign.start,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey.shade300, thickness: 1, height: 5.h),

            // Business Details
            _buildDetailRow(
              firstText: 'Business Interest: ',
              secondText:
                  'Consumer Electronics, Mobile Accessories, Repair Services',
            ),

            _buildDetailRow(
              firstText: 'Investment Capacity: ',
              secondText: ' ₹20–30 Lakhs',
            ),

            _buildDetailRow(
              firstText: 'Location: ',
              secondText: 'Nashik, Maharashtra',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightData() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send_rounded, size: 20.r, color: primaryColor),
            ),
            SizedBox(height: 8.h),
            CustomText(
              title: 'Send\nRequest',
              fontSize: 12.sp,
              maxLines: 2,
              color: textGrey,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightDataRequested() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Center(
          child: CustomText(
            title: 'Your request\nis pending',
            fontSize: 12.sp,
            maxLines: 4,
            color: textGrey,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildRightAccepted() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedCall02,
                color: primaryColor,
              ),
            ),
            // SizedBox(height: 8.h),
            Divider(),
            Container(
              width: 40.r,
              height: 40.r,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedMessage02,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String firstText,
    required String secondText,
  }) {
    return RichText(
      text: TextSpan(
        text: firstText,
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: secondText,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
