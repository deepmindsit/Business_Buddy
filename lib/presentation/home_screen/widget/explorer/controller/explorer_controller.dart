import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:geolocator/geolocator.dart';

@lazySingleton
class ExplorerController extends GetxController {
  final ApiService _apiService = Get.find();
  final isLoading = false.obs;
  final isFollowLoading = false.obs;
  final categories = [].obs;
  final currentIndex = 0.obs;
  int currentPage = 1;
  int totalPages = 1;
  int perPage = 10;
  bool hasMore = true;
  final isLoadMore = false.obs;

  Future<void> getCategories({
    bool showLoading = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      totalPages = 1;
      hasMore = true;
      categories.clear();
    }

    currentPage == 1 ? isLoading.value = showLoading : isLoadMore.value = true;

    try {
      final response = await _apiService.getCategories(currentPage.toString());
      if (response['common']['status'] == true) {
        final data = response['data'];

        final List list = data['categories'] ?? [];

        perPage = data['per_page'] ?? perPage;
        totalPages = data['total_pages'] ?? totalPages;

        /// 🔹 IMPORTANT
        if (isRefresh || currentPage == 1) {
          categories.assignAll(list); // 🔥 replaces list
        } else {
          categories.addAll(list); // pagination
        }

        /// 👇 backend-accurate pagination check
        hasMore = currentPage < totalPages;

        if (hasMore) currentPage++;
        // categories.value = response['data']['categories'] ?? [];
      }
    } catch (e) {
      ToastUtils.showToast(
        title: 'Something went wrong',
        description: e.toString(),
        type: ToastificationType.error,
        icon: Icons.error,
      );
      // debugPrint("Error: $e");
    } finally {
      if (showLoading) isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  /////////////////////////////////business List///////////////////////////////
  final isBusinessLoading = false.obs;
  final isDetailsLoading = false.obs;
  final businessDetails = {}.obs;
  final businessList = [].obs;
  final tabIndex = 0.obs;
  int currentBusinessPage = 1;
  int totalBusinessPages = 1;
  int pertBusinessPage = 10;
  bool hastBusinessMore = true;
  final isBusinessLoadMore = false.obs;

  Future<void> getBusinesses(
    String catId, {
    bool showLoading = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentBusinessPage = 1;
      totalBusinessPages = 1;
      hastBusinessMore = true;
      businessList.clear();
    }

    currentBusinessPage == 1
        ? isBusinessLoading.value = showLoading
        : isBusinessLoadMore.value = true;

    // if (showLoading) isBusinessLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';

    try {
      final lat = getIt<LocationController>().latitude.value.toString();
      final lng = getIt<LocationController>().longitude.value.toString();
      final response = await _apiService.explore(
        catId,
        '$lat,$lng',
        userId,
        currentBusinessPage.toString(),
      );
      if (response['common']['status'] == true) {
        final data = response['data'];

        final List list = data['businesses'] ?? [];

        pertBusinessPage = data['per_page'] ?? pertBusinessPage;
        totalBusinessPages = data['total_pages'] ?? totalBusinessPages;

        /// 🔹 IMPORTANT
        if (isRefresh || currentBusinessPage == 1) {
          businessList.assignAll(list); // 🔥 replaces list
        } else {
          businessList.addAll(list); // pagination
        }

        /// 👇 backend-accurate pagination check
        hastBusinessMore = currentBusinessPage < totalBusinessPages;

        if (hastBusinessMore) currentBusinessPage++;
      }
    } catch (e) {
      ToastUtils.showToast(
        title: 'Something went wrong',
        description: e.toString(),
        type: ToastificationType.error,
        icon: Icons.error,
      );
      // debugPrint("Error: $e");
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
    if (showLoading) businessDetails.clear();
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final lat = getIt<LocationController>().latitude.value.toString();
      final lng = getIt<LocationController>().longitude.value.toString();
      final response = await _apiService.businessDetails(
        businessId,
        '$lat,$lng',
        userId,
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
      // debugPrint("Error: $e");
    } finally {
      if (showLoading) isDetailsLoading.value = false;
    }
  }

  /////////////////////////////////add Review///////////////////////////////

  final rating = 0.0.obs;
  final reviewController = TextEditingController();
  final isSubmitting = false.obs;

  Future<void> addReview(String businessId, {bool showLoading = true}) async {
    if (showLoading) isSubmitting.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';

    try {
      final response = await _apiService.addReview(
        userId,
        businessId,
        reviewController.text.trim(),
        rating.value.toString(),
      );
      if (response['common']['status'] == true) {
        // await getBusinessDetails(businessId, showLoading: false);
        ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      ToastUtils.showToast(
        title: 'Something went wrong',
        description: e.toString(),
        type: ToastificationType.error,
        icon: Icons.error,
      );
      // debugPrint("Error: $e");
    } finally {
      Get.back();
      if (showLoading) isSubmitting.value = false;
    }
  }
}
