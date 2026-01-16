import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:geolocator/geolocator.dart';

@lazySingleton
class HomeController extends GetxController {
  final ApiService _apiService = Get.find();

  final isLoading = false.obs;
  final isMainLoading = false.obs;

  final feedsList = [].obs;
  final categoryList = [].obs;
  final requirementList = [].obs;
  final sliderList = [].obs;

  final _initialApiCalled = false.obs;

  @override
  void onInit() {
    super.onInit();

    _loadInitialHome();
    requestLocationPermission();

    // 🔄 React to location readiness
    final locationController = getIt<LocationController>();

    ever(locationController.isLocationReady, (ready) {
      if (ready == true && _initialApiCalled.value) {
        getHomeApi(showLoading: false);
      }
    });
  }

  Future<void> _loadInitialHome() async {
    isMainLoading.value = true;
    await getHomeApi();
    _initialApiCalled.value = true;
    isMainLoading.value = false;
  }

  /// ✅ Permission should NEVER block UI
  Future<bool> requestLocationPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Disabled',
          'Please enable location services',
        );
        await Geolocator.openLocationSettings();
        return false;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Permission Required',
          'Location permission is required to continue',
        );
        return false;
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Required',
          'Enable location permission from settings',
        );
        await Geolocator.openAppSettings();
        return false;
      }

      return true; // ✅ permission granted
    } catch (e) {
      // debugPrint('Location permission error: $e');
      return false;
    }
  }


  Future<void> getHomeApi({bool showLoading = true}) async {
    final locationController = getIt<LocationController>();

    final hasLocation = locationController.isLocationReady.value;

    final latLng = hasLocation
        ? '${locationController.latitude.value},${locationController.longitude.value}'
        : '';

    // final lat = getIt<LocationController>().latitude.value.toString();
    // final lng = getIt<LocationController>().longitude.value.toString();

    if (showLoading) isLoading.value = true;

    try {
      final userId = await LocalStorage.getString('user_id') ?? '';

      final response = await _apiService.getHome(latLng, userId);

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
