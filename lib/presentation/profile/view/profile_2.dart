import '../../../utils/exported_path.dart';

class ProfileScreen2 extends StatelessWidget {
  const ProfileScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [_buildProfileHeader(), _buildProfileDetails()],
        ),
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
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(Routes.editProfile),
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedPencilEdit02,
            color: Colors.grey,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedMessage02,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
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
              border: Border.all(color: Colors.blueGrey[100]!, width: 3),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.person, size: 40, color: Colors.grey[400]),
                ),
                errorWidget: (context, url, error) =>
                    Icon(Icons.person, size: 40, color: Colors.grey[400]),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Name
          Text(
            'Mr. Mangesh Ghodke',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
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
              title: 'Senior Flutter Developer',
              color: primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
          const SizedBox(height: 8),
          // Name
          GestureDetector(
            onTap: () => Get.toNamed(Routes.followingList),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  title: '50+',
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

  Widget _buildProfileDetails() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('About Me'),
          const SizedBox(height: 12),
          _buildAboutMeSection(),
          const SizedBox(height: 24),
          _buildSectionTitle('Professional Details'),
          const SizedBox(height: 12),
          _buildCategorySection(),
          const SizedBox(height: 24),
          _buildSectionTitle('Contact Information'),
          const SizedBox(height: 12),
          _buildContactSection(),
          const SizedBox(height: 24),
          _businessCard(),
          const SizedBox(height: 12),
          _buildLogoutButton(),
          _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildAboutMeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        'Dedicated medical professional with over 12 years of experience in internal medicine. '
        'Committed to providing exceptional patient care and staying current with the latest '
        'medical advancements. Special interest in preventive medicine and patient education.',
        style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey[700]),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryItem('Specialization', 'Internal Medicine'),
          const SizedBox(height: 12),
          _buildCategoryItem('Experience', '12 Years'),
          const SizedBox(height: 12),
          _buildCategoryItem('Education', 'MD, Internal Medicine'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _buildContactItem(
            HugeIcons.strokeRoundedMail01,
            'sarah.johnson@medical.com',
          ),
          const SizedBox(height: 12),
          _buildContactItem(HugeIcons.strokeRoundedCall02, '+1 (555) 123-4567'),
        ],
      ),
    );
  }

  Widget _buildContactItem(var icon, String text) {
    return Row(
      children: [
        HugeIcon(icon: icon, size: 20, color: primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _businessCard() {
    final businesses = [
      {
        'image': Images.hotelImg,
        'title': 'Hotel Jyoti Family....',
        'subtitle': 'Restaurant',
        'followers': '1200+ Followers',
      },
      {
        'image': Images.defaultImage,
        'title': 'Deepminds Infotech....',
        'subtitle': 'Information technology',
        'followers': '1200+ Followers',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Column(
          children: businesses.map((business) {
            return Container(
              margin: EdgeInsets.only(bottom: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.asset(
                        business['image']?.toString() ?? '',
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: business['title']?.toString() ?? '',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            business['subtitle']?.toString() ?? '',
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
                                business['followers']?.toString() ?? '',
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
                    HugeIcon(icon: HugeIcons.strokeRoundedPencilEdit02),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

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

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: () {
        AllDialogs().showConfirmationDialog(
          'Delete Account',
          'This will permanently delete your account. Continue?',
          onConfirm: () {
            // perform delete
            Get.back();
            Get.snackbar('Account Deleted', 'Your account has been removed');
          },
        );
      },
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        alignment: Alignment.center,
        child: CustomText(
          title: 'Delete account',
          fontSize: 16.sp,
          color: textLightGrey,
        ),
      ),
    );
  }
}
