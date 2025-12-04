import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class SpecialOfferController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoading = false.obs;
  final isApply = false.obs;
  final offerList = [].obs;

  Future<void> getSpecialOffer({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.getSpecialOffer(
        userId,
        selectedCategory.value,
        selectedDateRange.value,
      );

      if (response['common']['status'] == true) {
        offerList.value = response['data'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  ///////////////////////////////////////////filter//////////////////////////////////
  final selectedCategory = RxnString();

  final locations = ["Pune", "Mumbai", "Nagpur", "Delhi", "Bangalore"].obs;
  final selectedLocation = RxnString();

  final selectedDateRange = RxnString();
  DateTime? customStart, customEnd;

  Future<void> pickCustomDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      currentDate: DateTime.now(),
      saveText: 'Select',
    );

    if (picked != null) {
      customStart = picked.start;
      customEnd = picked.end;
      selectedDateRange.value =
          "${_formatDate(picked.start)},${_formatDate(picked.end)}";
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  void resetData() {
    selectedCategory.value = null;
    selectedLocation.value = null;
    customStart = null;
    customEnd = null;
    selectedDateRange.value = null;
    isApply.value = false;
  }
}
