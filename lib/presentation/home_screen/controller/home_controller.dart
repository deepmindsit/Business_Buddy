import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:geolocator/geolocator.dart';

@lazySingleton
class HomeController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoading = false.obs;
  final isLikeAnimating = false.obs;
  final feedsList = [].obs;
  final categoryList = [].obs;
  final requirementList = [].obs;
  final sliderList = [].obs;


  // ✅ Stores image ratio for each URL
  RxMap<String, bool> imageRatioMap = <String, bool>{}.obs;
  // true  = 9:16 (portrait)
  // false = 1:1  (square)

  void detectImageRatio(String url) {
    if (imageRatioMap.containsKey(url)) return;

    final Image image = Image.network(url);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, _) {
        final width = info.image.width.toDouble();
        final height = info.image.height.toDouble();
          print('width=============>$width');
          print('height=============>$height');
        if (height > width) {
          imageRatioMap[url] = true; // ✅ 9:16
        } else {
          imageRatioMap[url] = false; // ✅ 1:1
        }
      }),
    );
  }

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
