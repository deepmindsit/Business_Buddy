import 'dart:io';

import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class ProfileController extends GetxController {
  final ApiService _apiService = Get.find();
  final profileImage = Rx<File?>(null);
  final nameCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final educationCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final specialization = RxnString();
  final isLoading = false.obs;
  final profileDetails = {}.obs;
  final isMe = true.obs;

  void setPreselected() {
    nameCtrl.text = profileDetails['name'] ?? '';
    aboutCtrl.text = profileDetails['about'] ?? '';
    educationCtrl.text = profileDetails['education'] ?? '';
    experienceCtrl.text = profileDetails['experience'] ?? '';
    specialization.value =
        profileDetails['specialization_id'] ?? null;
  }

  Future<void> getProfile({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.getMyProfile(userId);

      if (response['common']['status'] == true) {
        profileDetails.value = response['data'] ?? {};
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> getUserProfile(String userId, {bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    try {
      final response = await _apiService.getUserProfile(userId);

      if (response['common']['status'] == true) {
        profileDetails.value = response['data'] ?? {};
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> updateProfile({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.updateProfile(
        userId,
        nameCtrl.text.trim(),
        experienceCtrl.text.trim(),
        educationCtrl.text.trim(),
        specialization.value!,
        aboutCtrl.text.trim(),
        profileImage: profileImage.value,
      );
      if (response['common']['status'] == true) {
        Get.back();
        await getProfile();
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }
}
