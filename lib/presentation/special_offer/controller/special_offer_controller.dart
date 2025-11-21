import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class SpecialOfferController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoading = false.obs;
  final offerList = [].obs;

  Future<void> getSpecialOffer({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.getSpecialOffer(userId);

      if (response['common']['status'] == true) {
        offerList.value = response['data'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }
}
