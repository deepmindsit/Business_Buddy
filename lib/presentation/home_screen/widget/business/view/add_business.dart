import 'package:businessbuddy/utils/exported_path.dart';

class AddBusiness extends StatefulWidget {
  const AddBusiness({super.key});

  @override
  State<AddBusiness> createState() => _AddBusinessState();
}

class _AddBusinessState extends State<AddBusiness> {
  final navController = getIt<NavigationController>();
  final controller = getIt<LBOController>();
  final expController = getIt<ExplorerController>();

  @override
  void initState() {
    expController.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _buildAddBusiness());
  }

  Widget _buildAddBusiness() =>
      Column(children: [_buildHeader(), _buildBody()]);

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => navController.backToHome(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 18.sp,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: CustomText(
              title: 'Add Business',
              textAlign: TextAlign.start,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: controller.businessKey,
        child: Column(
          spacing: 8,
          children: [
            Row(
              spacing: 12.w,
              children: [
                _buildProfileImage(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildLabel('Business/Shop Name'),
                      buildTextField(
                        controller: controller.shopName,
                        hintText: 'Enter Business/Shop Name',
                        keyboardType: TextInputType.name,
                        validator: (value) => value!.trim().isEmpty
                            ? 'Please enter Business/Shop Name'
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildAddress(),
            _buildNumber(),
            _buildOffering(),
            _buildReferralCode(),
            _buildAbout(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: buildLabel('Attachments'),
            ),

            _buildUploadDocuments(),
            _buildSelectedFilesWrap(),
            Obx(
              () => controller.isAddBusinessLoading.isTrue
                  ? LoadingWidget(color: primaryColor)
                  : _buildActionButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            radius: 41.r,
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Obx(() {
                  final imageFile = controller.profileImage.value;
                  final ImageProvider<Object> imageProvider = imageFile != null
                      ? FileImage(imageFile)
                      : const AssetImage(Images.defaultImage);

                  return FadeInImage(
                    placeholder: const AssetImage(Images.defaultImage),
                    image: imageProvider,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        Images.defaultImage,
                        width: 100.w,
                        height: 100.h,
                        fit: BoxFit.contain,
                      );
                    },
                    fit: BoxFit.contain,
                    placeholderFit: BoxFit.contain,
                    fadeInDuration: const Duration(milliseconds: 300),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 16.r,
              backgroundColor: primaryColor,
              child: Icon(Icons.edit, size: 16.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildLabel('Address'),
        ),
        buildTextField(
          controller: controller.address,
          hintText: 'Enter Address',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Address' : null,
        ),
      ],
    );
  }

  Widget _buildNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildLabel('Mobile Number'),
        ),
        buildTextField(
          controller: controller.numberCtrl,
          hintText: 'Enter your mobile number',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter mobile number';
            }
            if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
              return 'Enter a valid mobile number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildOffering() {
    return Obx(
      () => expController.isLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : AppDropdownField(
              title: 'Offering',
              isDynamic: true,
              value: controller.offering.value,
              items: expController.categories,
              hintText: 'Eg. Salon, Spa',
              validator: (value) =>
                  value == null ? 'Please select Offer' : null,
              onChanged: (val) async {
                controller.offering.value = val!;
              },
            ),
    );
  }

  Widget _buildReferralCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildLabel('Referral Code'),
        ),
        buildTextField(
          controller: controller.referCode,
          hintText: 'Enter Referral Code',
          validator: (value) => null,
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
          child: buildLabel('About Business'),
        ),
        buildTextField(
          maxLines: 3,
          controller: controller.aboutCtrl,
          hintText: 'Enter about',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter about' : null,
        ),
      ],
    );
  }

  Widget _buildUploadDocuments() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: GestureDetector(
        onTap: () {
          CustomFilePicker.showPickerBottomSheet(
            onFilePicked: (file) {
              controller.attachments.add(file);
            },
          );
        },
        child: DottedBorder(
          dashPattern: [10, 5],
          borderType: BorderType.RRect,
          radius: const Radius.circular(10),
          color: primaryGrey,
          strokeWidth: 1,
          padding: const EdgeInsets.all(16),
          child: Container(
            width: Get.width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
            child: Column(
              spacing: 8.h,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HugeIcon(icon: HugeIcons.strokeRoundedAddCircle),
                Text(
                  'Upload Images'.tr,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedFilesWrap() {
    return Obx(
      () => Wrap(
        spacing: 16,
        runSpacing: 8,
        children: controller.attachments.map((file) {
          final isImage =
              file.path.endsWith('.jpg') || file.path.endsWith('.png');

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: Get.width * 0.25.w,
                height: Get.width * 0.25.w,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isImage
                    ? Image.file(file, fit: BoxFit.cover)
                    : Center(
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedDocumentAttachment,
                          size: 40.sp,
                          color: Colors.grey,
                        ),
                      ),
              ),
              Positioned(
                top: -10,
                right: -10,
                child: InkWell(
                  onTap: () {
                    controller.attachments.remove(file);
                  },
                  child: CircleAvatar(
                    radius: 10.r,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, size: 12.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.close,
            text: 'Close',
            onPressed: () {},
            backgroundColor: primaryColor,
            isPrimary: false,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            icon: Icons.add,
            text: 'Add',
            onPressed: () async {
              if (controller.businessKey.currentState!.validate()) {
                await controller.addNewBusiness();
              }
            },
            backgroundColor: Colors.transparent,
            isPrimary: true,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isPrimary ? primaryColor : Colors.transparent,
          border: Border.all(
            color: isPrimary ? primaryColor : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: CustomText(
          title: text,
          fontSize: 16.sp,
          color: isPrimary ? Colors.white : primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
