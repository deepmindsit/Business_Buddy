import 'package:businessbuddy/utils/exported_path.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final controller = getIt<ProfileController>();

  @override
  void initState() {
    controller.setPreselected();
    getIt<ExplorerController>().getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0XFFFF383C).withValues(alpha: 0.4),
              Colors.white.withValues(alpha: 0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      title: CustomText(
        title: "Update Profile",
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildProfileImage() {
    final image = controller.profileDetails['profile_image'];
    return Center(
      child: GestureDetector(
        onTap: () {
          CustomFilePicker.showPickerBottomSheet(
            onFilePicked: (file) {
              controller.profileImage.value = file;
            },
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Obx(() {
              final imageFile = controller.profileImage.value;

              final ImageProvider<Object> imageProvider = imageFile != null
                  ? FileImage(imageFile)
                  : NetworkImage(image);

              return CircleAvatar(
                radius: 51.r,
                backgroundColor: Colors.grey.shade200,
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: lightGrey,
                  child: ClipOval(
                    child: FadeInImage(
                      placeholder: const AssetImage(Images.logo),
                      image: imageProvider,
                      fit: BoxFit.cover,
                      width: 120.r,
                      height: 120.r,
                      fadeInDuration: const Duration(milliseconds: 300),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          Images.defaultImage,
                          fit: BoxFit.cover,
                          width: 120.r,
                          height: 120.r,
                        );
                      },
                    ),
                  ),
                ),
              );
            }),
            Positioned(
              bottom: 8,
              right: -5,
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: primaryColor,
                child: Icon(Icons.edit, size: 16.sp, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        spacing: 12.h,
        children: [
          Row(
            spacing: 12.w,
            children: [
              _buildProfileImage(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildLabel('Your name'),
                    buildTextField(
                      controller: controller.nameCtrl,
                      hintText: 'Enter name',
                      keyboardType: TextInputType.name,
                      validator: (value) =>
                          value!.trim().isEmpty ? 'Please enter Name' : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildSpecialization(),
          _buildExperience(),
          _buildEducation(),
          _buildAbout(),
          SizedBox(height: 8.h),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildSpecialization() {
    return Obx(
      () => getIt<ExplorerController>().isLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : AppDropdownField(
              isDynamic: true,
              title: 'Specialization',
              value: controller.specialization.value,
              items: getIt<ExplorerController>().categories,
              hintText: 'Specialization',
              validator: (value) =>
                  value == null ? 'Please select specialization' : null,
              onChanged: (val) async {
                controller.specialization.value = val!;
              },
            ),
    );
  }

  Widget _buildExperience() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildLabel('Experience'),
        ),
        buildTextField(
          controller: controller.experienceCtrl,
          hintText: 'Enter Experience',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Experience' : null,
        ),
      ],
    );
  }

  Widget _buildEducation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildLabel('Education'),
        ),
        buildTextField(
          controller: controller.educationCtrl,
          hintText: 'Enter Education',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Education' : null,
        ),
      ],
    );
  }

  Widget _buildAbout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildLabel('About Me'),
        ),
        buildTextField(
          controller: controller.aboutCtrl,
          hintText: 'Enter About',
          maxLines: 4,
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter About' : null,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => controller.isLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : GestureDetector(
              onTap: () async {
                await controller.updateProfile();
              },
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                alignment: Alignment.center,
                child: CustomText(
                  title: 'Update Profile',
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
