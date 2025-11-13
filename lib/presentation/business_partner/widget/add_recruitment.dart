import 'package:businessbuddy/utils/exported_path.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddRecruitment extends StatefulWidget {
  const AddRecruitment({super.key});

  @override
  State<AddRecruitment> createState() => _AddRecruitmentState();
}

class _AddRecruitmentState extends State<AddRecruitment> {
  final controller = getIt<PartnerDataController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Form(
          key: controller.partnerKey,
          child: Column(
            spacing: 8.h,
            children: [
              _buildTitle(),
              _businessInterest(),
              _buildLocation(),
              _buildInvestmentType(),
              _buildCapacity(),
              _buildHistory(),
              _buildNote(),
              SizedBox(height: 12.h),
              _buildPostButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Recruitment Title'),
        buildTextField(
          controller: controller.recTitle,
          hintText: 'Enter your Recruitment Title',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Recruitment Title' : null,
        ),
      ],
    );
  }

  Widget _businessInterest() {
    return Column(
      children: [
        _buildLabel('Business Interest'),
        DropdownSearch<String>.multiSelection(
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: buildOutlineInputBorder(),
              enabledBorder: buildOutlineInputBorder(),
              focusedBorder: buildOutlineInputBorder(),
              contentPadding: const EdgeInsets.all(12),
              hintText: 'Business Interest',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select Interest';
            }
            return null;
          },
          items: (filter, infiniteScrollProps) =>
              controller.invTypes.map((item) => item.toString()).toList(),
          popupProps: PopupPropsMultiSelection.menu(
            showSelectedItems: false,
            menuProps: MenuProps(
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(maxHeight: 300),
          ),
          onChanged: (List<String> selectedItems) {
            controller.selectedBusiness.value = selectedItems.cast<String>();
          },
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Location'),
        buildTextField(
          controller: controller.location,
          hintText: 'Enter your Location',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Location' : null,
        ),
      ],
    );
  }

  Widget _buildInvestmentType() {
    return AppDropdownField(
      title: 'Investment',
      value: controller.invType.value,
      items: controller.invTypes,
      hintText: 'Select your Investment',
      validator: (value) => value == null ? 'Please select Investment' : null,
      onChanged: (val) async {
        controller.invType.value = val!;
      },
    );
  }

  Widget _buildCapacity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Investment Capacity'),
        buildTextField(
          controller: controller.invCapacity,
          hintText: 'Enter Investment Capacity',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Investment Capacity' : null,
        ),
      ],
    );
  }

  Widget _buildHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Investment History'),
        buildTextField(
          controller: controller.invHistory,
          hintText: 'Enter Investment History ',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Investment History ' : null,
        ),
      ],
    );
  }

  Widget _buildNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Note'),
        buildTextField(
          controller: controller.invHistory,
          hintText: 'Enter Note ',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Note' : null,
        ),
      ],
    );
  }

  Widget _buildPostButton() {
    return GestureDetector(
      onTap: () {
        if (controller.partnerKey.currentState!.validate()) {

        }
        // you can also access highlightPoints here
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
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: buildLabel(label),
    );
  }
}
