import '../../../utils/exported_path.dart';

@lazySingleton
class HomeGateController extends GetxController {
  final homeController = getIt<HomeController>();
  final locationController = getIt<LocationController>();

  final isReady = false.obs;
  final statusMessage = 'Starting…'.obs;

  @override
  void onInit() {
    super.onInit();
    startFlow();
  }

  Future<void> startFlow() async {
    try {
      statusMessage.value = 'Checking location permission…';
      await homeController.requestLocationPermission();

      statusMessage.value = 'Getting your location…';
      await locationController.fetchInitialLocation();
      getIt<SearchNewController>().getLiveLocation();
      statusMessage.value = 'Loading nearby data…';
      await homeController.getHomeApi();

      isReady.value = true;
    } catch (e) {
      statusMessage.value = 'Something went wrong. Please try again.';
    }
  }
}
