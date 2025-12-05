import 'package:businessbuddy/utils/exported_path.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String image;
  const CategoryCard({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 4.h,
      children: [
        Container(
          padding: EdgeInsets.all(22.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 0.5.w, color: lightGrey),
          ),
          child: FadeInImage(
            placeholder: AssetImage(Images.defaultImage),
            image: NetworkImage(image),
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(Images.defaultImage, fit: BoxFit.contain);
            },
            fit: BoxFit.contain,
            fadeInDuration: const Duration(milliseconds: 300),
          ),
        ),
        CustomText(
          title: name,
          fontSize: 14.sp,
          maxLines: 2,
          style: TextStyle(height: 1),
        ),
      ],
    );
  }
}
