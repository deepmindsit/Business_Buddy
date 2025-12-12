import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:geolocator/geolocator.dart';

@lazySingleton
class HomeController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoading = false.obs;
  final isMainLoading = false.obs;
  final isLikeAnimating = false.obs;
  final feedsList = [].obs;
  final categoryList = [].obs;
  final requirementList = [].obs;
  final sliderList = [].obs;

  @override
  void onReady() async {
    super.onReady();
    await requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Permission Required", "Enable location from settings");
      return;
    }
  }

  Future<void> getHomeApi({bool showLoading = true}) async {
    // Position position = await Geolocator.getCurrentPosition(
    //   desiredAccuracy: LocationAccuracy.high,
    // );
    final lat = getIt<LocationController>().latitude.value.toString();
    final lng = getIt<LocationController>().longitude.value.toString();
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.getHome('$lat,$lng', userId);

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
