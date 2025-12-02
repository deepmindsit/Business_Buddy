import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class InboxController extends GetxController {
  final ApiService _apiService = Get.find();

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

  ///////////////////////////////////////chat////////////////////////////////
  final allChats = [].obs;
  final singleChat = {}.obs;
  final isChatLoading = true.obs;
  final isSingleLoading = true.obs;
  final isSendLoading = false.obs;
  final msgController = TextEditingController();

  Future<void> getAllChat({bool showLoading = true}) async {
    if (showLoading) isChatLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.getChatList(userId);

      if (response['common']['status'] == true) {
        allChats.value = response['data'] ?? [];
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isChatLoading.value = false;
    }
  }

  Future<void> getSingleChat(String chatId, {bool showLoading = true}) async {
    if (showLoading) isSingleLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.getSingleChat(userId, chatId);

      if (response['common']['status'] == true) {
        singleChat.value = response['data'] ?? {};
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isSingleLoading.value = false;
    }
  }

  Future<void> sendMsg(String chatId, {bool showLoading = true}) async {
    if (showLoading) isSendLoading.value = true;
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.sendMsg(
        userId,
        chatId,
        msgController.text.trim(),
      );

      if (response['common']['status'] == true) {
        await getSingleChat(chatId, showLoading: false);
        msgController.clear();
        // ToastUtils.showSuccessToast(response['common']['message'].toString());
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      showError(e);
    } finally {
      if (showLoading) isSendLoading.value = false;
    }
  }

  final initiateLoadingMap = <String, bool>{}.obs;

  Future<void> initiateChat(String reqId) async {
    initiateLoadingMap[reqId] = true;
    initiateLoadingMap.refresh();
    final userId = await LocalStorage.getString('user_id') ?? '';
    try {
      final response = await _apiService.initiateChat(userId, reqId);

      if (response['common']['status'] == true) {
        getIt<NavigationController>().openSubPage(
          SingleChat(
            chatId:
                response['data']['business_requirement_chat_details']['business_requirement_chat_id']
                    ?.toString() ??
                '',
          ),
        );
      } else {
        ToastUtils.showErrorToast(response['common']['message'].toString());
      }
    } catch (e) {
      showError(e);
    } finally {
      initiateLoadingMap[reqId] = false;
      initiateLoadingMap.refresh();
    }
  }

  ///////////////////////////////////////request////////////////////////////////

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
