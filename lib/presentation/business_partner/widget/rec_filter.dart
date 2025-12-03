import 'package:businessbuddy/utils/exported_path.dart';

class RecruitmentFilter extends StatefulWidget {
  const RecruitmentFilter({super.key});

  @override
  State<RecruitmentFilter> createState() => _RecruitmentFilterState();
}

class _RecruitmentFilterState extends State<RecruitmentFilter> {
  final controller = getIt<PartnerDataController>();

  @override
  void initState() {
    loadAllData();
    super.initState();
  }

  Future<void> loadAllData() async {
    controller.isFilterLoading.value = true;
    await Future.wait([
      controller.getWulf(),
      getIt<ExplorerController>().getCategories(),
    ]);
    controller.isFilterLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.85,
      minChildSize: 0.50,
      builder: (_, scroll) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              Text(
                "Filters",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: Obx(
                  () => controller.isFilterLoading.isTrue
                      ? LoadingWidget(color: primaryColor)
                      : SingleChildScrollView(
                          controller: scroll,
                          child: Column(
                            spacing: 16.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// CATEGORY
                              dropList(
                                getIt<ExplorerController>().categories,
                                controller.selectedCategory.value,
                                (v) {
                                  controller.selectedCategory.value = v;
                                },
                                "Category",
                                true,
                              ),

                              /// LOOKING FOR
                              dropList(
                                controller.wulfList,
                                controller.lookingFor.value,
                                (v) async {
                                  controller.lookingFor.value = v;
                                  controller.selectedExp.value = null;
                                  await controller.getCapacity(v);
                                },
                                "Looking For",
                                true,
                              ),

                              _buildCapacity(),

                              /// LOCATION
                              dropList(
                                controller.locations,
                                controller.selectedLocation.value,
                                (v) {
                                  controller.selectedLocation.value;
                                },
                                "Location",
                                false,
                              ),

                              /// SORT ORDER
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Sort Order", style: title),
                                  Row(
                                    children: [
                                      radioTile("Ascending"),
                                      radioTile("Descending"),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 35),
                            ],
                          ),
                        ),
                ),
              ),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.selectedCategory.value = null;
                        controller.selectedExp.value = null;
                        controller.selectedLocation.value = null;
                        controller.lookingFor.value = null;
                        controller.sort.value = "Ascending";
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                      ),
                      child: Text("Reset", style: TextStyle(color: Colors.red)),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        // final body = {
                        //   "category": controller.selectedCategory.value,
                        //   "experience": controller.selectedExp.value,
                        //   "location": controller.selectedLocation.value,
                        //   "sort": controller.sort.value!.toLowerCase(),
                        //   "looking_for": controller.lookingFor.value,
                        // };

                        controller.changeTab(0);
                        await controller.getBusinessRequired();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "Apply",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // CUSTOM UI COMPONENTS
  Widget dropList(
    List items,
    String? selected,
    Function(String) onSelect,
    String title,
    bool isDynamic,
  ) {
    return AppDropdownField(
      isDynamic: isDynamic,
      title: title,
      value: selected,
      items: items,
      hintText: 'Select your $title',
      validator: (value) => value == null ? 'Please select $title' : null,
      onChanged: (v) => onSelect(v!),
    );
  }

  Widget radioTile(String text) {
    return Row(
      children: [
        Radio(
          value: text,
          groupValue: controller.sort.value,

          onChanged: (v) => controller.sort.value = v.toString(),
          activeColor: primaryColor,
        ),
        Text(text),
      ],
    );
  }

  Widget _buildCapacity() {
    return Obx(() {
      String title;

      switch (controller.lookingFor.value) {
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
                controller.selectedExp.value = val!;
              },
            );
    });
  }

  TextStyle get title => TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
}
