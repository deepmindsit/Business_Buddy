import 'dart:io';
import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:geolocator/geolocator.dart';

@lazySingleton
class LBOController extends GetxController {
  final ApiService _apiService = Get.find();
  final NavigationController navController = getIt<NavigationController>();

  /// ------------------------
  /// IMAGE PICKER
  /// ------------------------
  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } catch (e) {
      showError(e);
    }
  }

  /// ------------------------
  /// BUSINESS LIST
  /// ------------------------
  final isBusinessLoading = false.obs;
  final businessList = <dynamic>[].obs;
  final postList = <dynamic>[].obs;
  final offerList = <dynamic>[].obs;
  final selectedBusinessId = ''.obs;
  final isBusinessApproved = ''.obs;
  final isDetailsLoading = false.obs;
  final businessDetails = {}.obs;

  Future<void> getMyBusinesses({bool showLoading = true}) async {
    if (showLoading) isBusinessLoading.value = true;

    final userId = await LocalStorage.getString('user_id') ?? '';

    try {
      final response = await _apiService.myBusiness(userId);

      if (response['common']['status'] == true) {
        businessList.value = response['data']['businesses'] ?? [];

        if (businessList.isNotEmpty) {
          final firstBusiness = businessList.first;

          postList.value = firstBusiness['posts'] ?? [];
          offerList.value = firstBusiness['offers'] ?? [];
          selectedBusinessId.value = firstBusiness['id'].toString();
          isBusinessApproved.value = firstBusiness['is_business_approved']
              .toString();
        }
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isBusinessLoading.value = false;
    }
  }

  Future<void> getMyBusinessDetails(
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
      final response = await _apiService.myBusinessDetails(
        businessId,
        '${position.latitude},${position.longitude}',
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
      debugPrint("Error: $e");
    } finally {
      if (showLoading) isDetailsLoading.value = false;
    }
  }

  /// ------------------------
  /// ADD NEW BUSINESS
  /// ------------------------
  final profileImage = Rx<File?>(null);
  final businessKey = GlobalKey<FormState>();

  final shopName = TextEditingController();
  final address = TextEditingController();
  final referCode = TextEditingController();
  final numberCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final offering = RxnString();
  final attachments = <File>[].obs;
  final selectedBusiness = RxnInt();
  final isAddBusinessLoading = false.obs;

  Future<void> addNewBusiness() async {
    isAddBusinessLoading.value = true;

    final userId = await LocalStorage.getString('user_id') ?? '';

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final docs = await prepareDocuments(attachments);

      final response = await _apiService.addBusiness(
        userId,
        shopName.text.trim(),
        address.text.trim(),
        numberCtrl.text.trim(),
        offering.value,
        aboutCtrl.text.trim(),
        '${position.latitude},${position.longitude}',
        referCode.text.trim(),
        profileImage: profileImage.value,
        attachment: docs,
      );

      if (response['common']['status'] == true) {
        navController.backToHome();
        clearData();
        ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      showError(e);
    } finally {
      isAddBusinessLoading.value = false;
    }
  }

  void clearData() {
    shopName.clear();
    address.clear();
    numberCtrl.clear();
    aboutCtrl.clear();
    referCode.clear();
    offering.value = '';
    profileImage.value = null;
    attachments.clear();
  }

  /// ------------------------
  /// ADD NEW POST
  /// ------------------------
  final postImage = Rx<File?>(null);
  final postAbout = TextEditingController();
  final isPostLoading = false.obs;

  Future<void> addNewPost() async {
    isPostLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';

    try {
      final response = await _apiService.addPost(
        userId,
        selectedBusinessId.value,
        postAbout.text.trim(),
        profileImage: postImage.value,
      );

      if (response['common']['status'] == true) {
        Get.offAllNamed(Routes.mainScreen);
        ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      showError(e);
    } finally {
      isPostLoading.value = false;
    }
  }

  /// ------------------------
  /// ADD NEW OFFER
  /// ------------------------
  final offerImage = Rx<File?>(null);
  final titleCtrl = TextEditingController();
  final startDateCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final highlightCtrl = TextEditingController();
  final points = <String>[].obs;
  final isOfferLoading = false.obs;
  final offerKey = GlobalKey<FormState>();

  Future<void> addNewOffer() async {
    isOfferLoading.value = true;

    final userId = await LocalStorage.getString('user_id') ?? '';

    try {
      final response = await _apiService.addOffer(
        userId,
        selectedBusinessId.value,
        titleCtrl.text.trim(),
        descriptionCtrl.text.trim(),
        startDateCtrl.text.trim(),
        endDateCtrl.text.trim(),
        points,
        profileImage: offerImage.value,
      );

      if (response['common']['status'] == true) {
        clearOfferData();
        Get.offAllNamed(Routes.mainScreen);
        ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      showError(e);
    } finally {
      isOfferLoading.value = false;
    }
  }

  void clearOfferData() {
    offerImage.value = null;
    titleCtrl.clear();
    startDateCtrl.clear();
    endDateCtrl.clear();
    descriptionCtrl.clear();
    highlightCtrl.clear();
    points.clear();
  }

  /// ------------------------
  /// SINGLE POST DETAILS
  /// ------------------------
  final singlePost = <String, dynamic>{}.obs;
  final isSinglePostLoading = false.obs;

  Future<void> getSinglePost(String postId, {bool showLoading = true}) async {
    if (showLoading) isSinglePostLoading.value = true;

    try {
      final response = await _apiService.postDetails(postId);

      if (response['common']['status'] == true) {
        singlePost.value = response['data'] ?? {};
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isSinglePostLoading.value = false;
    }
  }

  /// ------------------------
  /// SINGLE OFFER DETAILS
  /// ------------------------
  final singleOffer = <String, dynamic>{}.obs;
  final isSingleOfferLoading = false.obs;

  Future<void> getSingleOffer(String offerId, {bool showLoading = true}) async {
    if (showLoading) isSingleOfferLoading.value = true;

    try {
      final response = await _apiService.offerDetails(offerId);

      if (response['common']['status'] == true) {
        singleOffer.value = response['data'] ?? {};
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isSingleOfferLoading.value = false;
    }
  }

  /// ------------------------
  /// COMMON ERROR HANDLER
  /// ------------------------
}
