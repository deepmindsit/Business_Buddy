import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class InboxController extends GetxController {
  final ApiService _apiService = Get.find();
  final controller = TextEditingController();
  final messages = [
    {'text': 'Hi there! 👋', 'isMe': false},
    {'text': 'Hey! How are you?', 'isMe': true},
    {
      'text': 'I’m good, just working on a new Flutter project 😄',
      'isMe': false,
    },
    {'text': 'Nice! Flutter makes UI so easy to build.', 'isMe': true},
    {'text': 'Totally agree with you! 🚀', 'isMe': false},
  ].obs;

  final isLoading = true.obs;
  final receivedRequestList = [].obs;

  Future<void> getReceiveBusinessRequest({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.getBusinessReceivedRequest(userId);

      if (response['common']['status'] == true) {
        receivedRequestList.value = response['data'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> acceptRequest(String reqId, {bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.acceptBusinessRequest(userId, reqId);

      if (response['common']['status'] == true) {
        await getReceiveBusinessRequest();
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
