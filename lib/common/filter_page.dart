import 'package:businessbuddy/utils/exported_path.dart';

class FeedSheet extends StatefulWidget {
  final String isFrom;
  const FeedSheet({super.key, required this.isFrom});

  @override
  State<FeedSheet> createState() => _FeedSheetState();
}

class _FeedSheetState extends State<FeedSheet> {
  final controller = getIt<SpecialOfferController>();

  @override
  void initState() {
    getIt<ExplorerController>().getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      // initialChildSize: 0.75,
      maxChildSize: 0.85.h,
      minChildSize: 0.50.h,
      builder: (_, scroll) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 5.h,
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20.r),
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
                  () => getIt<ExplorerController>().isLoading.isTrue
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
                                'Category',
                                true,
                              ),

                              /// LOCATION
                              dropList(
                                controller.locations,
                                controller.selectedLocation.value,
                                (v) {
                                  controller.selectedLocation.value = v;
                                },
                                'Location',
                                false,
                              ),

                              /// DATE RANGE
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 8.0,
                                      bottom: 6,
                                    ),
                                    child: buildLabel("Date Range"),
                                  ),
                                  Container(
                                    decoration: box,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      dense: true,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Colors.red,
                                          width: 0.2,
                                        ), //
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      title: Obx(
                                        () => Text(
                                          controller.selectedDateRange.value ??
                                              "Select Date Range",
                                          style: TextStyle(
                                            color:
                                                controller
                                                        .selectedDateRange
                                                        .value !=
                                                    null
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (controller
                                                  .selectedDateRange
                                                  .value !=
                                              null)
                                            IconButton(
                                              icon: Icon(Icons.clear, size: 20),
                                              onPressed: controller.resetData,
                                              color: Colors.grey,
                                            ),
                                          Icon(Icons.calendar_today, size: 20),
                                        ],
                                      ),
                                      onTap: controller.pickCustomDateRange,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 16),
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
                      onPressed: () async {
                        controller.selectedCategory.value = null;
                        controller.selectedLocation.value = null;
                        controller.customStart = null;
                        controller.customEnd = null;
                        controller.selectedDateRange.value = null;
                        Get.back();
                        if (widget.isFrom == 'feed') {
                          await getIt<FeedsController>().getFeeds();
                        } else {
                          await controller.getSpecialOffer();
                        }
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
                        Get.back();
                        if (widget.isFrom == 'feed') {
                          await getIt<FeedsController>().getFeeds();
                        } else {
                          await controller.getSpecialOffer();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Colors.white,
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

  BoxDecoration get box => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.r),
    border: Border.all(color: Colors.grey, width: 0.2),
  );
}
