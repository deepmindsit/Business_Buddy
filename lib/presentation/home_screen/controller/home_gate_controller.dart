import '../../../utils/exported_path.dart';

@lazySingleton
class HomeGateController extends GetxController {
  final homeController = getIt<HomeController>();
  final locationController = getIt<LocationController>();

  final isReady = false.obs;
  final hasError = false.obs;
  final statusMessage = 'Starting…'.obs;

  @override
  void onInit() {
    super.onInit();
    startFlow();
  }

  Future<void> startFlow() async {
    try {
      if (getIt<SearchNewController>().address.value.isEmpty) {
        statusMessage.value = 'Checking location permission…';
        // await homeController.requestLocationPermission();

        final permissionGranted = await homeController
            .requestLocationPermission();

        if (!permissionGranted) {
          statusMessage.value = 'Location permission is required to continue';
          hasError.value = true;
          return; // 🚫 STOP FLOW
        }

        statusMessage.value = 'Getting your location…';
        await locationController.fetchInitialLocation();
        getIt<SearchNewController>().getLiveLocation();
        statusMessage.value = 'Loading nearby data…';
      }

      await homeController.getHomeApi();

      isReady.value = true;
    } catch (e) {
      statusMessage.value = 'Something went wrong. Please try again.';
    }
  }
}
