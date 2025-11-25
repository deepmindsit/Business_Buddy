import 'package:businessbuddy/utils/exported_path.dart';
import 'package:dropdown_search/dropdown_search.dart';

class EditRecruitment extends StatefulWidget {
  final dynamic recruitmentData;
  const EditRecruitment({super.key, required this.recruitmentData});

  @override
  State<EditRecruitment> createState() => _EditRecruitmentState();
}

class _EditRecruitmentState extends State<EditRecruitment> {
  final controller = getIt<PartnerDataController>();
  final navController = getIt<NavigationController>();
  final catController = getIt<ExplorerController>();

  @override
  void initState() {
    loadAllData();
    controller.preselectedRecruitment(widget.recruitmentData);
    super.initState();
  }

  Future<void> loadAllData() async {
    controller.isMainLoading.value = true;
    await Future.wait([controller.getWulf(), catController.getCategories()]);
    controller.isMainLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isMainLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Form(
                key: controller.partnerKey,
                child: Column(
                  spacing: 8.h,
                  children: [
                    _buildHeader(),
                    Divider(height: 5),
                    _buildTitle(),
                    _businessInterest(),
                    _buildLocation(),
                    _buildInvestmentType(),
                    _buildCapacity(),
                    Obx(() {
                      if (controller.invType.value == '2') {
                        return _buildCanInvest();
                      }
                      return SizedBox();
                    }),
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

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        spacing: 8,
        children: [
          GestureDetector(
            onTap: () => navController.goBack(),
            child: const Icon(Icons.arrow_back),
          ),
          CustomText(
            title: 'Edit Post Recruitment',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
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
          selectedItems: controller.selectedBusiness,
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
          items: (filter, infiniteScrollProps) => catController.categories
              .map((item) => item['name'].toString())
              .toList(),
          popupProps: PopupPropsMultiSelection.menu(
            showSelectedItems: false,
            menuProps: MenuProps(
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(maxHeight: 300),
          ),
          onChanged: (List<String> selectedItems) {
            controller.selectedBusiness.assignAll(getIdsByNames(selectedItems));
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
      isDynamic: true,
      title: 'What are u looking for',
      value: controller.invType.value,
      items: controller.wulfList,
      hintText: 'Select your Investment',
      validator: (value) => value == null ? 'Please select Investment' : null,
      onChanged: (val) async {
        controller.invType.value = val!;
        controller.invCapacity.value = null;
        await controller.getCapacity(val);
      },
    );
  }

  Widget _buildCanInvest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('I can Invest'),
        buildTextField(
          controller: controller.iCanInvest,
          hintText: 'Enter your i can Invest',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter i can Invest' : null,
        ),
      ],
    );
  }

  Widget _buildCapacity() {
    return Obx(() {
      String title;

      switch (controller.invType.value) {
        case '1':
          title = 'Investment Capacity(Lacks)';
          break;
        case '2':
          title = 'Investment Requirement(Lacks)';
          break;
        case '3':
          title = 'Experience(Years)';
          break;
        default:
          title = 'Investment Capacity(Lacks)';
      }

      return controller.isLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : AppDropdownField(
              isDynamic: true,
              title: title,
              // value: controller.invCapacity.value,
              items: controller.capacityList,
              hintText: title,
              validator: (value) =>
                  value == null ? 'Please select $title' : null,
              onChanged: (val) {
                controller.invCapacity.value = val!;
              },
            );
    });
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
          controller: controller.notes,
          hintText: 'Enter Note ',
          validator: (value) =>
              value!.trim().isEmpty ? 'Please enter Note' : null,
        ),
      ],
    );
  }

  Widget _buildPostButton() {
    return Obx(
      () => controller.isAddLoading.isTrue
          ? LoadingWidget(color: primaryColor)
          : GestureDetector(
              onTap: () async {
                if (controller.partnerKey.currentState!.validate()) {
                  await controller.addBusinessRequired();
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
            ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: buildLabel(label),
    );
  }

  List<String> getIdsByNames(List<String> names) {
    return names
        .map((name) {
          final item = catController.categories.firstWhere(
            (e) => e['name'] == name,
            orElse: () => null,
          );
          return item?['id'].toString() ?? '';
        })
        .where((id) => id.isNotEmpty)
        .toList();
  }
}
