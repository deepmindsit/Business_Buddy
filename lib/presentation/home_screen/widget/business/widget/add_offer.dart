import 'package:businessbuddy/utils/exported_path.dart';
import 'package:intl/intl.dart';

class AddOffer extends StatefulWidget {
  const AddOffer({super.key});

  @override
  State<AddOffer> createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  final controller = getIt<LBOController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarPlain(title: "New Offer"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: controller.offerKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileImage(),
              Divider(height: 32.h),
              _buildLabel('Title'),
              buildTextField(
                controller: controller.titleCtrl,
                hintText: 'Enter title',
                validator: (value) =>
                    value!.trim().isEmpty ? 'Please enter title' : null,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      'Start Date',
                      controller.startDateCtrl,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildDateField('End Date', controller.endDateCtrl),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _buildLabel('Description'),
              buildTextField(
                controller: controller.descriptionCtrl,
                hintText: 'Enter description',
                maxLines: 3,
                validator: (value) =>
                    value!.trim().isEmpty ? 'Please enter description' : null,
              ),
              SizedBox(height: 20.h),
              _buildHighlightSection(),
              SizedBox(height: 24.h),
              _buildAddOfferButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: Get.width * 0.7,
            height: Get.height * 0.3,
            decoration: BoxDecoration(
              border: Border.all(color: lightGrey, width: 0.5.w),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Obx(() {
              final imageFile = controller.offerImage.value;
              final ImageProvider<Object> imageProvider = imageFile != null
                  ? FileImage(imageFile)
                  : const AssetImage(Images.defaultImage);

              return ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: FadeInImage(
                  placeholder: const AssetImage(Images.logo),
                  image: imageProvider,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      Images.defaultImage,
                      fit: BoxFit.contain,
                    );
                  },
                  fit: BoxFit.cover,
                  placeholderFit: BoxFit.contain,
                  fadeInDuration: const Duration(milliseconds: 300),
                ),
              );
            }),
          ),
          Positioned(
            bottom: -10,
            right: -10,
            child: GestureDetector(
              onTap: () {
                CustomFilePicker.showPickerBottomSheet(
                  onFilePicked: (file) {
                    controller.offerImage.value = file;
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

  Widget _buildDateField(String label, TextEditingController dateController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          controller: dateController,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            focusedBorder: buildOutlineInputBorder(),
            enabledBorder: buildOutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            prefixIcon: Icon(
              Icons.calendar_today,
              color: textGrey,
              size: 20.sp,
            ),
            hintText: 'Select date',
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: primaryColor,
                      onPrimary: Colors.black,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              dateController.text = DateFormat('yyyy-MM-dd').format(picked);
            }
          },
        ),
      ],
    );
  }

  Widget _buildHighlightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Highlight Points'),

        Obx(() {
          if (controller.points.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                "No highlights added yet.",
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.points.length,
            separatorBuilder: (_, __) => SizedBox(height: 6.h),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.points[index],
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.points.removeAt(index),
                      child: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.highlightCtrl,
                decoration: InputDecoration(
                  hintText: 'Add highlight point',
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: buildOutlineInputBorder(),
                  enabledBorder: buildOutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () {
                if (controller.highlightCtrl.text.trim().isNotEmpty) {
                  controller.points.add(controller.highlightCtrl.text.trim());
                  controller.highlightCtrl.clear();
                }
              },
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.add, color: Colors.white, size: 20.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddOfferButton() {
    return Obx(
      () => controller.isOfferLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : GestureDetector(
              onTap: () async {
                if (controller.offerKey.currentState!.validate()) {
                  await controller.addNewOffer();
                }
              },
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
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

  Widget _buildLabel(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.0.w, bottom: 6.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
