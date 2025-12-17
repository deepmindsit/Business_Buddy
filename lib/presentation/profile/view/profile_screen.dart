import '../../../utils/exported_path.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = getIt<ProfileController>();

  @override
  void initState() {
    super.initState();
    checkIsMe();
  }

  void checkIsMe() async {
    final isMe = Get.arguments['user_id'] ?? 'self';
    if (isMe == 'self') {
      controller.isMe.value = true;
      await controller.getProfile();
    } else {
      controller.isMe.value = false;
      await controller.getUserProfile(isMe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return LoadingWidget(color: primaryColor);
        }

        return SingleChildScrollView(
          child: Column(
            children: [_buildProfileHeader(), _buildProfileDetails()],
          ),
        );
      }),
    );
  }

  // ✅---------------- APP BAR ----------------✅
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
      title: Obx(
        () => CustomText(
          title: controller.isMe.isTrue ? "My Account" : 'Profile',
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Obx(
          () => IconButton(
            onPressed: controller.isMe.isTrue
                ? () => Get.toNamed(Routes.editProfile)
                : () {},
            icon: HugeIcon(
              icon: controller.isMe.isTrue
                  ? HugeIcons.strokeRoundedPencilEdit02
                  : HugeIcons.strokeRoundedMessage02,
              color: controller.isMe.isTrue ? Colors.grey : primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  // ✅---------------- PROFILE HEADER ----------------✅
  Widget _buildProfileHeader() {
    final image = controller.profileDetails['profile_image'] ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueGrey.shade100, width: 3),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (_, __) => Image.asset(Images.defaultImage),
                errorWidget: (_, __, ___) => Image.asset(Images.defaultImage),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Name
          CustomText(
            title: controller.profileDetails['name'] ?? '',
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
            color: Colors.grey[800],
          ),
          const SizedBox(height: 8),
          // Category
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
            ),
            child: CustomText(
              title: controller.profileDetails['specialization'] ?? '-',
              color: primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
          const SizedBox(height: 8),
          // Name
          GestureDetector(
            onTap: () => Get.toNamed(
              Routes.followingList,
              arguments: {
                'user_id': controller.profileDetails['id']?.toString() ?? '',
              },
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  title:
                      controller.profileDetails['followed_businesses_count']
                          ?.toString() ??
                      '-',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                SizedBox(width: 6.w),
                CustomText(
                  title: 'Following',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.r,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅---------------- PROFILE DETAILS ----------------✅
  Widget _buildProfileDetails() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.profileDetails['about'] != null) ...[
            _buildSectionTitle('About Me'),
            _buildAboutMeSection(),
          ],

          _buildSectionTitle('Professional Details'),

          _buildCategorySection(),
          if (controller.isMe.isTrue) ...[
            _buildSectionTitle('Contact Information'),

            _buildContactSection(),
          ],
          _businessCard(),
          _businessRequirement(),
          if (controller.isMe.isTrue) ...[_buildLogoutButton()],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildAboutMeSection() {
    final about = controller.profileDetails['about'] ?? '';
    // if (about == null) return SizedBox();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: CustomText(
        title: about,
        maxLines: 10,
        fontSize: 15.sp,
        color: Colors.grey[700],
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryItem(
            'Specialization',
            controller.profileDetails['specialization'] ?? '-',
          ),
          const SizedBox(height: 12),
          _buildCategoryItem(
            'Experience',
            controller.profileDetails['experience'] ?? '-',
          ),
          const SizedBox(height: 12),
          _buildCategoryItem(
            'Education',
            controller.profileDetails['education'] ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, String value) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: Text(title, style: _labelStyle())),
        Expanded(flex: 3, child: Text(value, style: _valueStyle())),
      ],
    );
  }

  Widget _buildContactSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        spacing: 12.h,
        children: [
          _buildContactItem(
            HugeIcons.strokeRoundedMail01,
            controller.profileDetails['email_id'] ?? '-',
          ),
          _buildContactItem(
            HugeIcons.strokeRoundedCall02,
            controller.profileDetails['mobile_number'] ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(var icon, String text) {
    return Row(
      spacing: 12.w,
      children: [
        HugeIcon(icon: icon, size: 20.r, color: primaryColor),
        Expanded(child: Text(text, style: _valueStyle())),
      ],
    );
  }

  // ✅---------------- BUSINESS CARD ----------------✅
  Widget _businessCard() {
    final businesses = controller.profileDetails['businesses'] ?? [];
    if (businesses.length == 0) return const SizedBox();
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Business'),
        Column(
          children: businesses.map<Widget>((business) {
            return Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(10.w),
              decoration: _boxDecoration(),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      business['image']?.toString() ?? '',
                      width: 50.w,
                      height: 50.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        Images.defaultImage,
                        width: 50.w,
                        height: 50.h,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: business['name']?.toString() ?? '',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          business['category']?.toString() ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(
                              Icons.people_alt_outlined,
                              size: 14.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${business['followers']?.toString() ?? '0'} Followers',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (controller.isMe.isTrue)
                    HugeIcon(icon: HugeIcons.strokeRoundedPencilEdit02),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ✅---------------- Business Requirement CARD ----------------✅
  Widget _businessRequirement() {
    final businesses = controller.profileDetails['business_requirements'] ?? [];
    if (businesses.length == 0) return const SizedBox();
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Business Requirements'),
        Column(
          children: businesses.map<Widget>((business) {
            return BusinessCard(data: business);
          }).toList(),
        ),
      ],
    );
  }

  // ✅---------------- LOGOUT ----------------✅
  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        AllDialogs().showConfirmationDialog(
          'Logout',
          'Are you sure you want to logout?',
          onConfirm: () {
            // perform logout
            Get.back();
            LocalStorage.clear();
            Get.snackbar('Logout', 'You have logged out successfully');
            Get.offAllNamed(Routes.login);
          },
        );
      },
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

  // ✅---------------- COMMON STYLES ----------------✅
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
      ],
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.grey[600],
      fontSize: 14.sp,
    );
  }

  TextStyle _valueStyle() {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.grey[800],
      fontSize: 14.sp,
    );
  }

  // Widget _buildDeleteButton() {
  //   return GestureDetector(
  //     onTap: () {
  //       AllDialogs().showConfirmationDialog(
  //         'Delete Account',
  //         'This will permanently delete your account. Continue?',
  //         onConfirm: () {
  //           // perform delete
  //           Get.back();
  //           Get.snackbar('Account Deleted', 'Your account has been removed');
  //         },
  //       );
  //     },
  //     child: Container(
  //       width: Get.width,
  //       padding: EdgeInsets.symmetric(vertical: 14.h),
  //       alignment: Alignment.center,
  //       child: CustomText(
  //         title: 'Delete account',
  //         fontSize: 16.sp,
  //         color: textLightGrey,
  //       ),
  //     ),
  //   );
  // }
}
