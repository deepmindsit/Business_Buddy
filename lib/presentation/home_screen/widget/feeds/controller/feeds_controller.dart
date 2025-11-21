import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:geolocator/geolocator.dart';

@lazySingleton
class FeedsController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoading = false.obs;
  final isFollowProcessing = false.obs;
  final isLikeProcessing = false.obs;
  final feedList = [].obs;

  Future<void> getFeeds({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.getFeeds(
        '${position.latitude},${position.longitude}',
        userId,
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

  final followingLoadingMap = <String, bool>{}.obs;

  Future<void> followBusiness(
    String businessId, {
    bool showLoading = true,
  }) async {
    followingLoadingMap[businessId] = true;
    followingLoadingMap.refresh();

    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.followBusiness(userId, businessId);

      if (response['common']['status'] == true) {
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      followingLoadingMap[businessId] = false;
      followingLoadingMap.refresh();
    }
  }

  Future<void> unfollowBusiness(
    String followId, {
    bool showLoading = true,
  }) async {
    followingLoadingMap[followId] = true;
    followingLoadingMap.refresh();

    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.unfollowBusiness(userId, followId);

      if (response['common']['status'] == true) {
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      followingLoadingMap[followId] = false;
      followingLoadingMap.refresh();
    }
  }

  final likeLoadingMap = <String, bool>{}.obs;

  Future<void> likeBusiness(
    String businessId,
    String postId, {
    bool showLoading = true,
  }) async {
    likeLoadingMap[postId] = true;
    likeLoadingMap.refresh();

    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.likeBusiness(
        userId,
        businessId,
        postId,
      );

      if (response['common']['status'] == true) {
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      likeLoadingMap[postId] = false;
      likeLoadingMap.refresh();
    }
  }

  Future<void> unLikeBusiness(String likeId, {bool showLoading = true}) async {
    likeLoadingMap[likeId] = true;
    likeLoadingMap.refresh();

    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.unlikeBusiness(userId, likeId);

      if (response['common']['status'] == true) {
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      likeLoadingMap[likeId] = false;
      likeLoadingMap.refresh();
    }
  }
}
