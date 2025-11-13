import 'dart:io';
import 'package:businessbuddy/components/documents_preparation.dart';
import 'package:businessbuddy/utils/exported_path.dart' hide Position;
import 'package:geolocator/geolocator.dart';

@lazySingleton
class LBOController extends GetxController {
  final ApiService _apiService = Get.find();
  final navController = getIt<NavigationController>();

  //////////////////////add offer///////////////////////
  final offerImage = Rx<File?>(null);
  final titleCtrl = TextEditingController();
  final startDateCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final highlightCtrl = TextEditingController();
  final points = [].obs;

  void pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  /////////////////////////////////My business List///////////////////////////////
  final isBusinessLoading = false.obs;
  final businessList = [].obs;
  final postList = [].obs;
  final offerList = [].obs;
  final selectedBusinessId = ''.obs;

  Future<void> getMyBusinesses({bool showLoading = true}) async {
    if (showLoading) isBusinessLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    final auth = await LocalStorage.getString('auth_key') ?? '';
    print('userId');
    print(userId);
    print(auth);
    businessList.clear();
    try {
      final response = await _apiService.myBusiness(userId);
      if (response['common']['status'] == true) {
        businessList.value = response['data']['businesses'] ?? [];
        if (businessList.isNotEmpty) {
          postList.value = businessList.first['posts'] ?? [];
          offerList.value = businessList.first['offers'] ?? [];
          selectedBusinessId.value = businessList.first['id'].toString();
        }
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

  //////////////////////////////add new business///////////////////////////
  final profileImage = Rx<File?>(null);
  final businessKey = GlobalKey<FormState>();
  final shopName = TextEditingController();
  final address = TextEditingController();
  final referCode = TextEditingController();
  final numberCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final offering = RxnString();
  final attachments = <File>[].obs;
  final selectedBusiness = RxnInt(0);
  final isAddBusinessLoading = false.obs;

  Future<void> addNewBusiness() async {
    isAddBusinessLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    businessList.clear();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    try {
      final docs = await prepareDocuments(attachments);
      final response = await _apiService.addBusiness(
        userId,
        shopName.text,
        address.text,
        numberCtrl.text,
        offering.value,
        aboutCtrl.text,
        '${position.latitude},${position.longitude}',
        referCode.text,
        profileImage: profileImage.value,
        attachment: docs,
      );
      print('response');
      print(response);
      if (response['common']['status'] == true) {
        navController.backToHome();
        clearData();
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
      debugPrint("Error: $e");
    } finally {
      isAddBusinessLoading.value = false;
    }
  }

  clearData() {
    shopName.clear();
    address.clear();
    numberCtrl.clear();
    offering.value = '';
    aboutCtrl.clear();
    referCode.clear();
    profileImage.value = null;
    attachments.clear();
  }

  //////////////////////////////add new post///////////////////////////

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
      print('response');
      print(response);
      if (response['common']['status'] == true) {
        navController.backToHome();
        clearData();
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
      debugPrint("Error: $e");
    } finally {
      isPostLoading.value = false;
    }
  }
}
