import 'dart:io';
import 'package:businessbuddy/utils/exported_path.dart';
import 'package:flutter/cupertino.dart';

class AllDialogs {
  void noInternetDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: const Text(
            'No Internet Connection',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Images.noInternet, width: Get.height * 0.25.w),
              const SizedBox(height: 12),
              const Text('Please check your internet connection.'),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final isConnected =
                    await InternetConnectionChecker.instance.hasConnection;
                if (isConnected) {
                  if (Get.isDialogOpen ?? false) Get.back();
                  // await checkMaintenance();
                } else {
                  // Optionally show a toast/snackbar
                }
              },
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void changeNumber(String number) {
    if (Platform.isIOS) {
      // iOS style dialog
      showCupertinoDialog(
        context: Get.context!,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text('Change Number'),
          content: Text('Are you sure you want to change\n+91 $number'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx),
              isDestructiveAction: true,
              child: const Text('No'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                getIt<OnboardingController>().numberController.clear();
                Get.offAllNamed(Routes.login);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    } else {
      // Android style dialog
      Get.dialog(
        AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content: Text('Are you sure you want to change\n+91 $number'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('No', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                getIt<OnboardingController>().numberController.clear();
                Get.offAllNamed(Routes.login);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
  }

  void offerDialog(dynamic offers) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height * 0.7.h),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: 'Latest Local Offers Just for You!',
                      fontSize: 18.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, color: Colors.grey, size: 20.sp),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                const Divider(),
                // Offers list

                // Offers list
                offers.isEmpty
                    ? Center(
                        child: CustomText(
                          title: 'No offers available',
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      )
                    : Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: 8.h),
                          itemCount: offers.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final offer = offers[index];
                            return _buildOfferTile(offer);
                          },
                        ),
                      ),
                // SizedBox(height: 8.h),
                //
                // _buildOfferTile(),
                // SizedBox(height: 12.h),
                // _buildOfferTile(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showConfirmationDialog(
    String title,
    String message, {
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      Dialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 50.sp,
                color: Colors.redAccent,
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: onConfirm,
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferTile(dynamic offer) {
    return OfferTile(
      point: offer['highlight_points'] ?? [],
      imageUrl: offer['image'] ?? '',
      restaurantName: offer['business_name'] ?? '',
      offerTitle: offer['details'] ?? '',
      dateRange: '${offer['start_date'] ?? ''} to ${offer['end_date'] ?? ''}  ',
    );
  }
}

class OfferTile extends StatelessWidget {
  final String imageUrl;
  final String restaurantName;
  final String offerTitle;
  final String dateRange;
  final List point;

  const OfferTile({
    super.key,
    required this.imageUrl,
    required this.restaurantName,
    required this.offerTitle,
    required this.dateRange,
    required this.point,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imageUrl,
              height: 60.h,
              width: 60.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.w),

          // Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurantName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  offerTitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      dateRange,
                      style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: point.map((v) {
                    return buildBulletPoint(text: v);
                  }).toList(),
                ),

                // _buildBulletPoint(text: 'No minimum order'),
                // _buildBulletPoint(text: 'Extra cheese free on weekend orders'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildBulletPoint({required String text}) {
  return Row(
    children: [
      // Bullet point
      Container(
        margin: EdgeInsets.only(right: 8.w),
        width: 8.r,
        height: 8.r,
        decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
      ),
      // Text
      Expanded(
        child: CustomText(
          title: text,
          fontSize: 12.sp,
          color: Colors.grey.shade700,
          textAlign: TextAlign.start,
        ),
      ),
    ],
  );
}

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  // CATEGORY LIST
  List<String> categories = [
    "IT & Software",
    "Marketing",
    "Finance",
    "Education",
    "Real Estate",
    "Health",
    "Construction",
    "Hospitality",
    "Automobile",
    "Manufacturing",
  ];
  String? selectedCategory;

  // EXPERIENCE
  List<String> expList = ["0-1 yrs", "1-3 yrs", "3-5 yrs", "5+ yrs"];
  String? selectedExp;

  // LOCATION
  List<String> locations = ["Pune", "Mumbai", "Nagpur", "Delhi", "Bangalore"];
  String? selectedLocation;

  // SORT
  String sort = "Ascending"; // Asc / Desc

  // LOOKING FOR
  List<String> lookingList = ["Investor", "Investment", "Expert"];
  String? lookingFor;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.85,
      minChildSize: 0.50,
      builder: (_, scroll) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: SingleChildScrollView(
                  controller: scroll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// CATEGORY
                      Text("Category", style: title),
                      dropList(categories, selectedCategory, (v) {
                        setState(() => selectedCategory = v);
                      }),

                      SizedBox(height: 16),

                      /// EXPERIENCE
                      Text("Experience", style: title),
                      dropList(expList, selectedExp, (v) {
                        setState(() => selectedExp = v);
                      }),

                      SizedBox(height: 16),

                      /// LOCATION
                      Text("Location", style: title),
                      dropList(locations, selectedLocation, (v) {
                        setState(() => selectedLocation = v);
                      }),

                      SizedBox(height: 16),

                      /// SORT ORDER
                      Text("Sort Order", style: title),
                      Row(
                        children: [
                          radioTile("Ascending"),
                          radioTile("Descending"),
                        ],
                      ),

                      SizedBox(height: 12),

                      /// LOOKING FOR
                      Text("Looking For", style: title),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 10,
                        children: lookingList.map((e) {
                          bool isSel = lookingFor == e;
                          return GestureDetector(
                            onTap: () => setState(() => lookingFor = e),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: isSel
                                      ? primaryColor
                                      : Colors.grey.shade400,
                                  width: isSel ? 2 : 1,
                                ),
                                color: isSel
                                    ? primaryColor.withValues(alpha: 0.1)
                                    : null,
                              ),
                              child: Text(
                                e,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isSel ? primaryColor : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 35),
                    ],
                  ),
                ),
              ),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = null;
                          selectedExp = null;
                          selectedLocation = null;
                          lookingFor = null;
                          sort = "Ascending";
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                      ),
                      child: Text("Reset", style: TextStyle(color: Colors.red)),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          "category": selectedCategory,
                          "experience": selectedExp,
                          "location": selectedLocation,
                          "sort": sort,
                          "looking_for": lookingFor,
                        });
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
  Widget dropList(List items, String? selected, Function(String) onSelect) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: box,
      child: DropdownButton<String>(
        dropdownColor: Colors.white,

        isExpanded: true,
        underline: SizedBox(),
        value: selected,
        hint: Text("Select"),
        items: items
            .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => onSelect(v!),
      ),
    );
  }

  Widget radioTile(String text) {
    return Row(
      children: [
        Radio(
          value: text,
          groupValue: sort,

          onChanged: (v) => setState(() => sort = v.toString()),
          activeColor: primaryColor,
        ),
        Text(text),
      ],
    );
  }

  TextStyle get title => TextStyle(fontSize: 15, fontWeight: FontWeight.w600);

  BoxDecoration get box => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey.shade400),
  );
}

class FeedSheet extends StatefulWidget {
  const FeedSheet({super.key});

  @override
  State<FeedSheet> createState() => _FeedSheetState();
}

class _FeedSheetState extends State<FeedSheet> {
  // CATEGORY LIST
  List<String> categories = [
    "IT & Software",
    "Marketing",
    "Finance",
    "Education",
    "Real Estate",
    "Health",
    "Construction",
    "Hospitality",
    "Automobile",
    "Manufacturing",
  ];
  String? selectedCategory;

  // LOCATION
  List<String> locations = ["Pune", "Mumbai", "Nagpur", "Delhi", "Bangalore"];
  String? selectedLocation;

  // DATE RANGE
  final selectedDateRange = RxnString();
  DateTime? customStart, customEnd;

  Future<void> pickCustomDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      currentDate: DateTime.now(),
      saveText: 'Select',
    );

    if (picked != null && mounted) {
      setState(() {
        customStart = picked.start;
        customEnd = picked.end;
        selectedDateRange.value =
            "${_formatDate(picked.start)} - ${_formatDate(picked.end)}";
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _clearDateRange() {
    setState(() {
      customStart = null;
      customEnd = null;
      selectedDateRange.value = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      // initialChildSize: 0.75,
      maxChildSize: 0.85,
      minChildSize: 0.50,
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
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: SingleChildScrollView(
                  controller: scroll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// CATEGORY
                      Text("Category", style: title),
                      SizedBox(height: 8),
                      dropList(categories, selectedCategory, (v) {
                        setState(() => selectedCategory = v);
                      }),

                      SizedBox(height: 16),

                      /// LOCATION
                      Text("Location", style: title),
                      SizedBox(height: 8),
                      dropList(locations, selectedLocation, (v) {
                        setState(() => selectedLocation = v);
                      }),

                      SizedBox(height: 16),

                      /// DATE RANGE
                      Text("Date Range", style: title),
                      SizedBox(height: 8),
                      Container(
                        decoration: box,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          title: Obx(
                            () => Text(
                              selectedDateRange.value ?? "Select Date Range",
                              style: TextStyle(
                                color: selectedDateRange.value != null
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (selectedDateRange.value != null)
                                IconButton(
                                  icon: Icon(Icons.clear, size: 20),
                                  onPressed: _clearDateRange,
                                  color: Colors.grey,
                                ),
                              Icon(Icons.calendar_today, size: 20),
                            ],
                          ),
                          onTap: pickCustomDateRange,
                        ),
                      ),

                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Reset all filters
                        setState(() {
                          selectedCategory = null;
                          selectedLocation = null;
                          customStart = null;
                          customEnd = null;
                          selectedDateRange.value = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                      ),
                      child: Text("Reset", style: TextStyle(color: Colors.red)),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Return filter data
                        final Map<String, dynamic> filters = {
                          "category": selectedCategory,
                          "location": selectedLocation,
                          "date_range": selectedDateRange.value,
                          "start_date": customStart,
                          "end_date": customEnd,
                        };

                        // Navigate back with filter data
                        Navigator.pop(context, filters);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            primaryColor, // Make sure primaryColor is defined
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
  Widget dropList(List items, String? selected, Function(String) onSelect) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: box,
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: SizedBox(),
        value: selected,
        hint: Text("Select"),
        items: items
            .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => onSelect(v!),
      ),
    );
  }

  TextStyle get title => TextStyle(fontSize: 15, fontWeight: FontWeight.w600);

  BoxDecoration get box => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey.shade400),
  );
}
