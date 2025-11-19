import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:geolocator/geolocator.dart';

@lazySingleton
class PartnerDataController extends GetxController {
  final ApiService _apiService = Get.find();

  final isLoading = true.obs;
  final isAddLoading = false.obs;
  final isMainLoading = true.obs;
  final recTitle = TextEditingController();
  final location = TextEditingController();
  final invHistory = TextEditingController();
  final notes = TextEditingController();
  final iCanInvest = TextEditingController();
  final invType = RxnString();
  final invCapacity = RxnString();
  final partnerKey = GlobalKey<FormState>();
  final selectedBusiness = <String>[].obs;
  final requirementList = [].obs;
  final wulfList = [].obs;
  final capacityList = [].obs;

  Future<void> getBusinessRequired({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.businessReqList(userId);

      if (response['common']['status'] == true) {
        requirementList.value = response['data'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> getWulf({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    try {
      final response = await _apiService.getWulf();

      if (response['common']['status'] == true) {
        wulfList.value = response['data'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> getCapacity(String wulfId, {bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    try {
      capacityList.clear();
      final response = await _apiService.getCapacity(wulfId);

      if (response['common']['status'] == true) {
        capacityList.value = response['data'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> addBusinessRequired({bool showLoading = true}) async {
    if (showLoading) isAddLoading.value = true;
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final userId = await LocalStorage.getString('user_id') ?? '';

      final response = await _apiService.addBusinessReq(
        userId,
        recTitle.text.trim(),
        location.text.trim(),
        '${position.latitude},${position.longitude}',
        invType.value!,
        invCapacity.value!,
        invHistory.text.trim(),
        notes.text.trim(),
        iCanInvest.text.trim(),
        selectedBusiness,
      );
      if (response['common']['status'] == true) {
        resetField();
        getIt<NavigationController>().goBack();
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isAddLoading.value = false;
    }
  }

  resetField() {
    recTitle.clear();
    location.clear();
    invHistory.clear();
    iCanInvest.clear();
    notes.clear();
    invType.value = '';
    invCapacity.value = '';
    selectedBusiness.clear();
  }
}
