import 'package:businessbuddy/utils/exported_path.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final controller = getIt<LBOController>();

  @override
  void initState() {
    controller.postImage.value = null;
    controller.postAbout.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarPlain(title: "New Post"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          spacing: 12.h,
          children: [
            _buildProfileImage(),
            Divider(),
            buildTextField(
              maxLines: 3,
              controller: controller.postAbout,
              hintText: 'About Details',
              validator: (value) =>
                  value!.trim().isEmpty ? 'Please enter about' : null,
            ),
            _buildAddPostButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Obx(() {
            final imageFile = controller.postImage.value;
            final ImageProvider<Object> imageProvider = imageFile != null
                ? FileImage(imageFile)
                : const AssetImage(Images.defaultImage);
            return ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: FadeInImage(
                width: Get.width * 0.7.w,
                height: Get.height * 0.3.h,
                placeholder: const AssetImage(Images.logo),
                image: imageProvider,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    Images.defaultImage,
                    width: Get.width * 0.7.w,
                    height: Get.height * 0.3.h,
                    fit: BoxFit.cover,
                  );
                },
                fit: BoxFit.cover,
                placeholderFit: BoxFit.contain,
                fadeInDuration: const Duration(milliseconds: 300),
              ),
            );
          }),
          Positioned(
            bottom: 0,
            right: -10,
            child: GestureDetector(
              onTap: () {
                CustomFilePicker.showPickerBottomSheet(
                  onFilePicked: (file) {
                    controller.postImage.value = file;
                    // controller.postImage.add(file);
                  },
                );
              },
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: primaryColor,
                child: Icon(Icons.edit, size: 20.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPostButton() {
    return Obx(
      () => controller.isPostLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : GestureDetector(
              onTap: () async {
                await controller.addNewPost();
              },
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CustomText(
                  title: 'Post',
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
