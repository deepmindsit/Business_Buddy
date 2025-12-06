import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:geolocator/geolocator.dart';

@lazySingleton
class PartnerDataController extends GetxController {
  final ApiService _apiService = Get.find();

  final isLoading = true.obs;
  final isAddLoading = false.obs;
  final isSendLoading = false.obs;
  final isMainLoading = true.obs;
  final isFilterLoading = false.obs;
  final isCompleted = true.obs;
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

  late TabController tabController;
  final tabIndex = 0.obs;

  void changeTab(int index) {
    tabIndex.value = index;
    tabController.animateTo(index);
  }

  resetFilter() {
    selectedCategory.value = null;
    selectedExp.value = null;
    selectedLocation.value = null;
    lookingFor.value = null;
    sort.value = "";
  }

  Future<void> getBusinessRequired({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';

    print('selectedCategory.value');
    print(selectedCategory.value);
    print(sort.value!.toLowerCase());
    print(lookingFor.value);
    print(selectedExp.value);
    try {
      final response = await _apiService.businessReqList(
        userId,
        selectedCategory.value,
        sort.value!.toLowerCase(),
        lookingFor.value,
        selectedExp.value,
      );

      if (response['common']['status'] == true) {
        requirementList.value = response['data'] ?? [];
      } else {
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

  final requestedBusinessList = [].obs;

  Future<void> getRequestedBusiness({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    requestedBusinessList.clear();
    try {
      final userId = await LocalStorage.getString('user_id') ?? '';
      final response = await _apiService.getBusinessRequested(userId);

      if (response['common']['status'] == true) {
        requestedBusinessList.value = response['data'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  resetField() {
    recTitle.clear();
    location.clear();
    invHistory.clear();
    iCanInvest.clear();
    notes.clear();
    invType.value = null;
    invCapacity.value = '';
    selectedBusiness.clear();
  }

  void preselectedRecruitment(dynamic data) async {
    recTitle.text = data['name'] ?? '';
    location.text = data['location'] ?? '';
    invType.value = data['what_you_look_for_id'].toString();
    selectedBusiness.value = List<String>.from(data['category_names'] ?? []);
    await getCapacity(data['what_you_look_for_id'].toString()).then((v) {
      invCapacity.value = data['investment_capacity'] ?? '';
    });
  }

  ////////////////////////////////////////rec filter///////////////////////////////
  final selectedCategory = RxnString();

  final locations = ["Pune", "Mumbai", "Nagpur", "Delhi", "Bangalore"].obs;
  final selectedLocation = RxnString();

  // EXPERIENCE
  final expList = ["0-1 yrs", "1-3 yrs", "3-5 yrs", "5+ yrs"].obs;
  final selectedExp = RxnString();

  // SORT
  final sort = RxnString("");

  // LOOKING FOR
  final lookingList = ["Investor", "Investment", "Expert"].obs;
  final lookingFor = RxnString();
}
