import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:geolocator/geolocator.dart';

@lazySingleton
class FeedsController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoading = false.obs;
  final feedList = [].obs;

  Future<void> getFeeds({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    try {
      final response = await _apiService.getFeeds(
        '${position.latitude},${position.longitude}',
      );

      if (response['common']['status'] == true) {
        feedList.value = response['data'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }
}
