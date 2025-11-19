import 'package:businessbuddy/utils/exported_path.dart';

class BusinessCard extends StatefulWidget {
  final String status;
  final dynamic data;
  const BusinessCard({super.key, required this.status, this.data});

  @override
  State<BusinessCard> createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
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
            if (widget.data['self'] == true) _buildIsMeCondition(),
            if (widget.data['requested'] == true &&
                widget.data['accepted'] == false)
              _buildPendingRequested(),
            if (widget.data['requested'] == false &&
                widget.data['self'] == false)
              _buildSendRequest(),
            if (widget.data['requested'] == true &&
                widget.data['accepted'] == true)
              _buildAcceptedRequest(),
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
            Expanded(
              child: CustomText(
                title: widget.data['name'] ?? '',
                fontSize: 16.sp,
                textAlign: TextAlign.start,
                color: primaryColor,
                fontWeight: FontWeight.w600,
                maxLines: 2,
              ),
            ),
            Divider(color: Colors.grey.shade300, thickness: 1, height: 5.h),

            // Business Details
            _buildDetailRow(
              firstText: 'Business Interest: ',
              secondText: widget.data['category_names'].join(", "),
            ),

            widget.data['what_you_look_for_id'].toString() == '3'
                ? _buildDetailRow(
                    firstText: 'Experience: ',
                    secondText: widget.data['investment_capacity'] ?? '',
                  )
                : _buildDetailRow(
                    firstText: 'Investment Capacity: ',
                    secondText: widget.data['investment_capacity'] ?? '',
                  ),

            _buildDetailRow(
              firstText: 'Location: ',
              secondText: widget.data['location'] ?? '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendRequest() {
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

  Widget _buildIsMeCondition() {
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
              child: Icon(Icons.edit, size: 20.r, color: primaryColor),
            ),
            SizedBox(height: 8.h),
            CustomText(
              title: 'Edit',
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

  Widget _buildPendingRequested() {
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

  Widget _buildAcceptedRequest() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CustomText(
                title: 'Approved',
                fontSize: 12.sp,
                maxLines: 4,
                color: Colors.green,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),

            // Container(
            //   width: 40.r,
            //   height: 40.r,
            //   padding: EdgeInsets.all(8.r),
            //   decoration: BoxDecoration(
            //     color: primaryColor.withValues(alpha: 0.1),
            //     shape: BoxShape.circle,
            //   ),
            //   child: HugeIcon(
            //     icon: HugeIcons.strokeRoundedCall02,
            //     color: primaryColor,
            //   ),
            // ),
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
