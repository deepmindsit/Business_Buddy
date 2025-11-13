import 'package:businessbuddy/utils/exported_path.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = getIt<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          _buildProfileImage(),
          SizedBox(height: 12.h),
          Expanded(child: _buildBody()),
        ],
      ),
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
        title: "My Account",
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildProfileImage() {
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
                  : const AssetImage(Images.defaultImage);

              return CircleAvatar(
                radius: 62.r,
                backgroundColor: Colors.grey.shade200,
                child: CircleAvatar(
                  radius: 60.r,
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
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.r)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: 'Personal Info',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),
            _buildListTile(
              icon: HugeIcons.strokeRoundedUser03,
              title: 'Your name',
              subtitle: 'Mangesh',
            ),
            _buildListTile(
              icon: HugeIcons.strokeRoundedCall02,
              title: 'Phone Number',
              subtitle: '+91 12345 67890',
            ),
            _buildListTile(
              icon: HugeIcons.strokeRoundedMail01,
              title: 'Email Address',
              subtitle: 'mangesh@myexample.com',
            ),
            _buildListTile(
              icon: HugeIcons.strokeRoundedNote01,
              title: 'About Me',
              subtitle: 'I am 10 years experience bakery expert.',
              maxLines: 3,
            ),
            const Divider(),
            _buildOptionTile(
              icon: HugeIcons.strokeRoundedPencilEdit02,
              title: 'Edit Profile',
              onTap: () => Get.toNamed(Routes.editProfile),
            ),
            _buildOptionTile(
              icon: HugeIcons.strokeRoundedBriefcase01,
              title: 'My Business',
              onTap: () {},
            ),
            _buildOptionTile(
              icon: HugeIcons.strokeRoundedSearch01,
              title: 'Business Partner',
              onTap: () {},
            ),
            SizedBox(height: 16.h),

            _buildLogoutButton(),
            // _buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(100.r),
        ),
        alignment: Alignment.center,
        child: CustomText(
          title: 'Logout',
          fontSize: 16.sp,
          color: primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required var icon,
    required String title,
    required String subtitle,
    int maxLines = 1,
  }) {
    return ListTile(
      dense: true,
      leading: HugeIcon(icon: icon, size: 24),
      title: CustomText(
        title: title,
        fontSize: 12.sp,
        textAlign: TextAlign.start,
      ),
      subtitle: CustomText(
        textAlign: TextAlign.start,
        title: subtitle,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildOptionTile({
    required var icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      leading: HugeIcon(icon: icon, size: 24.r),
      title: CustomText(
        title: title,
        fontSize: 14.sp,
        textAlign: TextAlign.start,
      ),
      trailing: const Icon(Icons.arrow_forward_ios_sharp),
    );
  }
}
