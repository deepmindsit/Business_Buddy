import 'package:businessbuddy/utils/exported_path.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      elevation: 2,
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

            // Image Section
            _buildImageSection(),
            // SizedBox(height: 16.h),

            // Content Section
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: Colors.grey.shade100,
          backgroundImage: AssetImage(Images.hotelImg),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: 'Pizza Point Café',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.start,
                color: Colors.black87,
                maxLines: 1,
              ),
              SizedBox(height: 2.h),
              CustomText(
                title: 'Restaurants',
                fontSize: 12.sp,
                textAlign: TextAlign.start,
                color: Colors.grey.shade600,
                maxLines: 1,
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        _buildFollowButton(),
      ],
    );
  }

  Widget _buildFollowButton() {
    return GestureDetector(
      onTap: () {
        // Handle follow action
      },
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_add_alt_1_rounded,
              color: Colors.white,
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            CustomText(
              title: 'Follow',
              fontSize: 12.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: AspectRatio(
          aspectRatio: 1.4,
          child: FadeInImage(
            placeholder: const AssetImage(Images.logo),
            image: AssetImage(Images.offerImage),
            width: double.infinity,
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade100,
                child: Center(
                  child: Image.asset(Images.logo, width: 150.w, height: 150.w),
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
          title: 'Get 15% OFF on Your Family Dinner Bill!',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: primaryColor,
          textAlign: TextAlign.start,
          maxLines: 2,
        ),
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
                title: '28 Oct 2025 to 02 Nov 2025',
                fontSize: 14.sp,
                color: Colors.grey.shade700,
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Benefits Section with Bullet Points
        Column(
          spacing: 6.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBulletPoint(text: 'Valid on dine-in & takeaway'),
            _buildBulletPoint(text: 'No minimum order'),
            _buildBulletPoint(text: 'Extra cheese free on weekend orders'),
          ],
        ),
      ],
    );
  }

  Widget _buildBulletPoint({required String text}) {
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
}
