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
  final isFollowLoading = false.obs;
  final profileDetails = {}.obs;
  final followList = [].obs;
  final isMe = true.obs;

  void setPreselected() {
    nameCtrl.text = profileDetails['name'] ?? '';
    aboutCtrl.text = profileDetails['about'] ?? '';
    educationCtrl.text = profileDetails['education'] ?? '';
    experienceCtrl.text = profileDetails['experience']?.toString() ?? '';
    specialization.value =
        profileDetails['specialization_id']?.toString() ?? null;
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

  Future<void> getFollowList({
    String? user = '',
    bool showLoading = true,
  }) async {
    if (showLoading) isFollowLoading.value = true;
    final userId = await LocalStorage.getString('user_id');
    try {
      final response = await _apiService.getFollowList(user ?? userId);

      if (response['common']['status'] == true) {
        followList.value = response['data']['businesses'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isFollowLoading.value = false;
    }
  }

  ///////////////////////////////Legal Page//////////////////////////////////////

  final legalPageList = [].obs;
  final legalPageDetails = {}.obs;
  final legalLoading = false.obs;
  final detailsLoading = false.obs;

  Future<void> legalPageListApi({bool showLoading = true}) async {
    if (showLoading) legalLoading.value = true;

    try {
      final response = await _apiService.legalPageList();

      if (response['common']['status'] == true) {
        legalPageList.value = response['data']['pages'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) legalLoading.value = false;
    }
  }

  Future<void> legalPageDetailsApi(
    String slug, {
    bool showLoading = true,
  }) async {
    if (showLoading) detailsLoading.value = true;

    try {
      final response = await _apiService.legalPageDetails(slug);

      if (response['common']['status'] == true) {
        legalPageDetails.value = response['data'] ?? {};
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) detailsLoading.value = false;
    }
  }

  /////////////////////////delete profile///////////////////////////////
  Future<void> deleteProfile({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.deleteAccount(userId);

      if (response['common']['status'] == true) {
        ToastUtils.showSuccessToast(response['common']['message']);
        await LocalStorage.clear();
        Get.offAllNamed(Routes.login);
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
