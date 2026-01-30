import 'dart:ui';

import '../../../common/policy_data.dart';
import '../../../utils/exported_path.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = getIt<ProfileController>();
  final navController = getIt<NavigationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      checkIsMe();
    });
  }

  void checkIsMe() async {
    final isMe = Get.arguments['user_id'] ?? 'self';
    if (isMe == 'self') {
      controller.isMe.value = true;
      await controller.getProfile();
      await controller.legalPageListApi();
    } else {
      controller.isMe.value = false;
      await controller.getUserProfile(isMe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.light
                ? [primaryColor.withValues(alpha: 0.5), Colors.white]
                : [primaryColor, Colors.black54],
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
          color: primaryBlack,
        ),
      ),
      actions: [
        Obx(() {
          if (controller.isMe.isFalse) return SizedBox();
          return IconButton(
            onPressed: () => getIt<ThemeController>().toggleTheme(),
            icon: HugeIcon(
              icon: Theme.of(context).brightness == Brightness.light
                  ? HugeIcons.strokeRoundedSun01
                  : HugeIcons.strokeRoundedMoon02,
              color: primaryBlack,
            ),
          );
        }),
        Obx(() {
          if (controller.isMe.isFalse) return SizedBox();
          return IconButton(
            onPressed: () => Get.toNamed(Routes.editProfile),
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedPencilEdit02,
              color: primaryBlack,
            ),
          );
        }),
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
        color: Theme.of(context).scaffoldBackgroundColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.red.shade50,
        //     blurRadius: 8,
        //     offset: Offset(0, 2),
        //   ),
        // ],
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
            color: primaryBlack,
          ),
          const SizedBox(height: 8),
          // Category
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? primaryColor.withValues(alpha: 0.2)
                  : Colors.white,
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
                  color: primaryBlack,
                ),
                SizedBox(width: 6.w),
                CustomText(
                  title: 'Following',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: primaryBlack,
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.r,
                  color: primaryBlack,
                ),
              ],
            ),
          ),
          Divider(color: lightGrey, height: 1),
        ],
      ),
    );
  }

  // ✅---------------- PROFILE DETAILS ----------------✅
  Widget _buildProfileDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
          if (controller.legalPageList.isNotEmpty)
            Divider(
              color: Colors.grey.shade300,
              indent: Get.width * 0.04,
              endIndent: Get.width * 0.04,
            ),
          Column(
            children: List.generate(controller.legalPageList.length, (index) {
              final v = controller.legalPageList[index];
              return Column(
                children: [
                  ListTile(
                    visualDensity: VisualDensity(vertical: -4),
                    dense: true,
                    onTap: () {
                      Get.to(() => PolicyData(slug: v['slug'] ?? ''));
                    },
                    title: CustomText(
                      title: v['name'] ?? '',
                      fontSize: 16.sp,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.bold,
                      color: primaryBlack,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16.r,
                      color: Colors.grey,
                    ),
                  ),
                  if (index != controller.legalPageList.length - 1)
                    Divider(
                      color: Colors.grey.shade300,
                      indent: Get.width * 0.04,
                      endIndent: Get.width * 0.04,
                    ),
                ],
              );
            }),
          ),
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
        color: primaryBlack,
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
        color: primaryBlack,
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
            return GestureDetector(
              onTap: controller.isMe.isTrue
                  ? null
                  : () {
                      Get.back();
                      Get.back();
                      navController.openSubPage(
                        CategoryDetailPage(
                          title: business['name']?.toString() ?? '',
                          businessId: business['id']?.toString() ?? '',
                        ),
                      );
                    },
              child: Container(
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
                            color: primaryBlack,
                          ),
                          Text(
                            business['category']?.toString() ?? '',
                            style: TextStyle(fontSize: 12.sp, color: textGrey),
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
                                  color: textGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (controller.isMe.isTrue)
                      GestureDetector(
                        onTap: () => Get.toNamed(
                          Routes.editBusiness,
                          arguments: {'data': business},
                        ),
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedPencilEdit02,
                        ),
                      ),
                  ],
                ),
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
            return Stack(
              children: [
                BusinessCard(
                  data: business,
                  onDelete: () {
                    AllDialogs().showConfirmationDialog(
                      'Delete Recruitment',
                      'Are you sure you want to delete this recruitment?',
                      onConfirm: () async {
                        await getIt<PartnerDataController>()
                            .deleteBusinessRequirement(
                              business['id']?.toString() ?? '',
                            );
                        Get.back();
                        await controller.getProfile();
                      },
                    );
                  },
                ),

                /// 🔒 Blur Overlay
                if (business['is_deleted'] == true)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Get.theme.dividerColor,
                              width: 0.5.w,
                            ),
                            color: Colors.black.withValues(alpha: 0.25),
                          ),

                          alignment: Alignment.center,
                          child: Text(
                            'Deleted Requirement',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                /// ⋮ Menu Icon
                if (business['is_deleted'] == true)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: PopupMenuButton<String>(
                      color: Theme.of(Get.context!).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                      popUpAnimationStyle: AnimationStyle(
                        curve: Curves.easeInOut,
                      ),
                      padding: EdgeInsets.zero,
                      surfaceTintColor: Theme.of(
                        Get.context!,
                      ).scaffoldBackgroundColor,
                      onSelected: (value) async {
                        if (value == 'revoke') {
                          await getIt<PartnerDataController>()
                              .revokeBusinessRequirement(
                                business['id']?.toString() ?? '',
                              );
                          // _onRequestRevoke();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'revoke',
                          child:
                              getIt<PartnerDataController>()
                                  .isRevokeLoading
                                  .value
                              ? LoadingWidget(color: primaryColor)
                              : Text('Request Revoke'),
                        ),
                      ],
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(Icons.more_vert, color: primaryColor),
                      ),
                    ),
                  ),
              ],
            );
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
          color: Colors.grey.shade100,
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
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;

    return BoxDecoration(
      color: Get.theme.cardColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.grey.withValues(alpha: 0.3) : Colors.black12,
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(
      fontWeight: FontWeight.w500,
      color: textSmall,
      fontSize: 14.sp,
    );
  }

  TextStyle _valueStyle() {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: textLightGrey,
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
