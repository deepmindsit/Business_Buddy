import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:geolocator/geolocator.dart';

@lazySingleton
class ExplorerController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoading = false.obs;
  final categories = [].obs;

  Future<void> getCategories({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    print('userId==========>$userId');
    try {
      final response = await _apiService.getCategories();
      if (response['common']['status'] == true) {
        categories.value = response['data']['categories'] ?? [];
      }
    } catch (e) {
      ToastUtils.showToast(
        title: 'Something went wrong',
        description: e.toString(),
        type: ToastificationType.error,
        icon: Icons.error,
      );
      debugPrint("Error: $e");
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  /////////////////////////////////business List///////////////////////////////
  final isBusinessLoading = false.obs;
  final isDetailsLoading = false.obs;
  final businessDetails = {}.obs;
  final businessList = [].obs;


  Future<void> getBusinesses(String catId, {bool showLoading = true}) async {
    if (showLoading) isBusinessLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    // print('userId==========>$userId');
    businessList.clear();
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final response = await _apiService.explore(
        catId,
        '${position.latitude},${position.longitude}',userId
      );
      if (response['common']['status'] == true) {
        businessList.value = response['data']['businesses'] ?? [];
      }
    } catch (e) {
      ToastUtils.showToast(
        title: 'Something went wrong',
        description: e.toString(),
        type: ToastificationType.error,
        icon: Icons.error,
      );
      debugPrint("Error: $e");
    } finally {
      if (showLoading) isBusinessLoading.value = false;
    }
  }

  Future<void> getBusinessDetails(
    String businessId, {
    bool showLoading = true,
  }) async {
    if (showLoading) isDetailsLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    // print('userId==========>$userId');
    businessDetails.clear();
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final response = await _apiService.businessDetails(
        businessId,
        '${position.latitude},${position.longitude}',userId
      );
      if (response['common']['status'] == true) {
        businessDetails.value = response['data'] ?? {};
      }
    } catch (e) {
      ToastUtils.showToast(
        title: 'Something went wrong',
        description: e.toString(),
        type: ToastificationType.error,
        icon: Icons.error,
      );
      debugPrint("Error: $e");
    } finally {
      if (showLoading) isDetailsLoading.value = false;
    }
  }
}
