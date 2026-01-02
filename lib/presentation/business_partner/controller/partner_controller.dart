import 'package:businessbuddy/utils/exported_path.dart' hide Position;

@lazySingleton
class PartnerDataController extends GetxController {
  final ApiService _apiService = Get.find();

  /* -------------------- UI STATE -------------------- */
  final isLoading = true.obs;
  final isAddLoading = false.obs;
  final isSendLoading = false.obs;
  final isMainLoading = true.obs;
  final isFilterLoading = false.obs;

  /* -------------------- FORM CONTROLLERS -------------------- */

  final recTitle = TextEditingController();
  final location = TextEditingController();
  final invHistory = TextEditingController();
  final notes = TextEditingController();
  final iCanInvest = TextEditingController();

  final invType = RxnString();
  final invCapacity = RxnString();
  final partnerKey = GlobalKey<FormState>();

  /* -------------------- DATA -------------------- */

  final selectedBusiness = <String>[].obs;
  final requirementList = [].obs;
  final requestedBusinessList = [].obs;

  final wulfList = [].obs;
  final capacityList = [].obs;

  /* -------------------- TAB HANDLING -------------------- */

  late TabController tabController;
  final tabIndex = 0.obs;

  void changeTab(int index) {
    tabIndex.value = index;
    tabController.animateTo(index);
  }

  /* -------------------- FILTER -------------------- */

  final selectedCategory = RxnString();
  final selectedLocation = RxnString();
  final selectedExp = RxnString();
  final lookingFor = RxnString();
  final sort = RxnString("");
  final address = ''.obs;
  final addressList = [].obs;
  final addressController = TextEditingController();
  final lat = ''.obs;
  final lng = ''.obs;

  void resetFilter() {
    selectedCategory.value = null;
    selectedExp.value = null;
    selectedLocation.value = null;
    lookingFor.value = null;
    sort.value = "";
    addressController.clear();
    addressList.clear();
    lat.value = '';
    lng.value = '';
    address.value = '';
  }

  /* -------------------- PAGINATION (ALL BUSINESS) -------------------- */

  int currentBusinessPage = 1;
  int totalBusinessPages = 1;
  int pertBusinessPage = 10;
  bool hastBusinessMore = true;
  final isBusinessLoadMore = false.obs;

  Future<void> getBusinessRequired({
    bool showLoading = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentBusinessPage = 1;
      totalBusinessPages = 1;
      hastBusinessMore = true;
      requirementList.clear();
    }
    currentBusinessPage == 1
        ? isLoading.value = showLoading
        : isBusinessLoadMore.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';

    final latitude = getIt<LocationController>().latitude.value.toString();
    final longitude = getIt<LocationController>().longitude.value.toString();
    print('search.value=======>  ${lat.value},${lng.value},');
    print('live.value=======>$latitude,$longitude');
    print('currentBusinessPage=======>$currentBusinessPage');
    print('selectedCategory=======>$selectedCategory');
    print('sort=======>$sort');
    print('lookingFor=======>$lookingFor');
    print('selectedExp=======>$selectedExp');
    print('userId=======>$userId');
    try {
      final response = await _apiService.businessReqList(
        userId,
        selectedCategory.value,
        sort.value!.toLowerCase(),
        lookingFor.value,
        selectedExp.value,
        '$latitude,$longitude',
        currentBusinessPage.toString(),
        '${lat.value},${lng.value}',
      );
      print('getBusinessRequired');
      print(response);
      if (response['common']['status'] == true) {
        final data = response['data'];

        final List list = data['business_requirements'] ?? [];
        pertBusinessPage = data['per_page'] ?? pertBusinessPage;
        totalBusinessPages = data['total_pages'] ?? totalBusinessPages;

        /// 🔹 IMPORTANT
        if (isRefresh || currentBusinessPage == 1) {
          requirementList.assignAll(list); // 🔥 replaces list
        } else {
          requirementList.addAll(list); // pagination
        }

        /// 👇 backend-accurate pagination check
        hastBusinessMore = currentBusinessPage < totalBusinessPages;

        if (hastBusinessMore) currentBusinessPage++;
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  /* -------------------- ADD / EDIT /DELETE BUSINESS -------------------- */

  Future<void> addBusinessRequired({bool showLoading = true}) async {
    if (showLoading) isAddLoading.value = true;
    try {
      // final lat = getIt<LocationController>().latitude.value.toString();
      // final lng = getIt<LocationController>().longitude.value.toString();
      final userId = await LocalStorage.getString('user_id') ?? '';

      final response = await _apiService.addBusinessReq(
        userId,
        recTitle.text.trim(),
        addressController.text.trim(),
        '$lat,$lng',
        invType.value!,
        invCapacity.value!,
        invHistory.text.trim(),
        notes.text.trim(),
        iCanInvest.text.trim(),
        selectedBusiness,
      );
      _handleSuccess(response);

      // if (response['common']['status'] == true) {
      //   resetField();
      //   getIt<NavigationController>().goBack();
      //   ToastUtils.showSuccessToast(response['common']['message']);
      // } else {
      //   ToastUtils.showWarningToast(response['common']['message']);
      // }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isAddLoading.value = false;
    }
  }

  Future<void> editBusinessRequired(
    String businessId, {
    bool showLoading = true,
  }) async {
    if (showLoading) isAddLoading.value = true;
    try {
      final lat = getIt<LocationController>().latitude.value.toString();
      final lng = getIt<LocationController>().longitude.value.toString();
      final response = await _apiService.editBusinessReq(
        businessId,
        recTitle.text.trim(),
        location.text.trim(),
        '$lat,$lng',
        invType.value!,
        invCapacity.value!,
        invHistory.text.trim(),
        notes.text.trim(),
        iCanInvest.text.trim(),
        getIdsByNames(selectedBusiness),
      );
      _handleSuccess(response);
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isAddLoading.value = false;
    }
  }

  Future<void> deleteBusinessRequirement(
    String businessId, {
    bool showLoading = true,
  }) async {
    if (showLoading) isLoading.value = true;
    try {
      final response = await _apiService.deleteBusinessReq(businessId);

      if (response['common']['status'] == true) {
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

  void _handleSuccess(dynamic response) {
    if (response['common']['status'] == true) {
      resetField();
      getIt<NavigationController>().goBack();
      ToastUtils.showSuccessToast(response['common']['message']);
    } else {
      ToastUtils.showWarningToast(response['common']['message']);
    }
  }

  /* -------------------- HELPERS -------------------- */

  void resetField() {
    recTitle.clear();
    location.clear();
    invHistory.clear();
    iCanInvest.clear();
    notes.clear();
    invType.value = null;
    invCapacity.value = null;
    selectedBusiness.clear();
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

  List<String> getIdsByNames(List<String> names) {
    return names
        .map((name) {
          final item = getIt<ExplorerController>().categories.firstWhere(
            (e) => e['name'] == name,
            orElse: () => null,
          );
          return item?['id'].toString() ?? '';
        })
        .where((id) => id.isNotEmpty)
        .toList();
  }

  final businessLoadingMap = <String, bool>{}.obs;

  Future<void> sendBusinessRequest(
    String businessId, {
    bool showLoading = true,
  }) async {
    businessLoadingMap[businessId] = true;
    businessLoadingMap.refresh();
    if (showLoading) isSendLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.sendBusinessRequest(
        userId,
        businessId,
      );

      if (response['common']['status'] == true) {
        await getBusinessRequired();
        ToastUtils.showSuccessToast(response['common']['message']);
      } else {
        ToastUtils.showWarningToast(response['common']['message']);
      }
    } catch (e) {
      showError(e);
    } finally {
      businessLoadingMap[businessId] = false;
      businessLoadingMap.refresh();
    }
  }

  final isLoadMore = false.obs;

  int currentPage = 1;
  int totalPages = 1;
  int perPage = 10;
  bool hasMore = true;

  Future<void> getRequestedBusiness({
    bool showLoading = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentPage = 1;
      totalPages = 1;
      hasMore = true;
      requestedBusinessList.clear();
    }

    currentPage == 1 ? isLoading.value = showLoading : isLoadMore.value = true;
    try {
      final userId = await LocalStorage.getString('user_id') ?? '';
      final response = await _apiService.getBusinessRequested(
        userId,
        currentPage.toString(),
      );
      if (response['common']['status'] == true) {
        final data = response['data'];

        final List list = data['business_requirements'] ?? [];

        perPage = data['per_page'] ?? perPage;
        totalPages = data['total_pages'] ?? totalPages;

        /// 🔹 IMPORTANT
        if (isRefresh || currentPage == 1) {
          requestedBusinessList.assignAll(list); // 🔥 replaces list
        } else {
          requestedBusinessList.addAll(list); // pagination
        }

        /// 👇 backend-accurate pagination check
        hasMore = currentPage < totalPages;

        if (hasMore) currentPage++;
      }

      // if (response['common']['status'] == true) {
      //   requestedBusinessList.value = response['data'] ?? [];
      // }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  void preselectedRecruitment(dynamic data) async {
    recTitle.text = data['name'] ?? '';
    location.text = data['location'] ?? '';
    invHistory.text = data['history'] ?? '';
    notes.text = data['note'] ?? '';
    iCanInvest.text = data['can_invest'] ?? '';
    invType.value = data['what_you_look_for_id'].toString();
    selectedBusiness.value = List<String>.from(data['category_names'] ?? []);
    invCapacity.value = data['investment_capacity_id']?.toString() ?? '';
    await getCapacity(data['what_you_look_for_id'].toString()).then((v) {});
  }

  // ////////////////////////////////////////rec filter///////////////////////////////
  // final selectedCategory = RxnString();
  //
  // final locations = ["Pune", "Mumbai", "Nagpur", "Delhi", "Bangalore"].obs;
  // final selectedLocation = RxnString();
  //
  // // EXPERIENCE
  // final selectedExp = RxnString();
  //
  // // SORT
  // final sort = RxnString("");
  //
  // // LOOKING FOR
  // final lookingList = ["Investor", "Investment", "Expert"].obs;
  // final lookingFor = RxnString();
}
