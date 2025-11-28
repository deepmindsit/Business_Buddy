import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:geolocator/geolocator.dart';

@lazySingleton
class HomeController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoading = false.obs;
  final feedsList = [].obs;
  final categoryList = [].obs;
  final requirementList = [].obs;
  final sliderList = [].obs;

  Future<void> getHomeApi({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.getHome(
        '${position.latitude},${position.longitude}',
        userId,
      );

      if (response['common']['status'] == true) {
        final data = response['data'] ?? {};

        feedsList.value = data['feeds'] ?? [];
        categoryList.value = data['categories'] ?? [];
        requirementList.value = data['business_requirements'] ?? [];
        sliderList.value = data['sliders'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }
}
