import 'package:businessbuddy/utils/exported_path.dart';

Widget buildReviewTile({
  required String userName,
  required String review,
  required int rating,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 20.r,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: AssetImage(Images.hotelImg),
      ),
      SizedBox(width: 12.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: userName,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            SizedBox(height: 4.h),
            CustomText(
              title: review,
              textAlign: TextAlign.start,
              fontSize: 13.sp,
              color: Colors.grey.shade700,
              maxLines: 20,
            ),
            buildStarRating(rating),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    ],
  );
}

Widget buildStarRating(int rating) {
  return Row(
    children: List.generate(5, (index) {
      return Icon(
        Icons.star_rounded,
        color: index < rating ? Colors.amber : Colors.grey.shade300,
        size: 16.sp,
      );
    }),
  );
}

Widget buildGridImages(dynamic data) {
  if (data.isEmpty) {
    return Center(
      child: Text(
        'No items available',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      ),
    );
  }
  return GridView.builder(
    padding: EdgeInsets.only(top: 8.h),
    itemCount: data.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 8.w,
      crossAxisSpacing: 8.w,
      childAspectRatio: 1,
    ),
    itemBuilder: (context, index) {
      final image = data[index];
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: FadeInImage.assetNetwork(
          placeholder: Images.defaultImage,
          image: image['image'] ?? '',
          fit: BoxFit.cover,
          imageErrorBuilder: (_, __, ___) =>
              Image.asset(Images.defaultImage, fit: BoxFit.cover),
        ),
      );
    },
  );
}

// Image.network(image['image'], fit: BoxFit.cover),
