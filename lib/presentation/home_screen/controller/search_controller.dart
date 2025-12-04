import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class SearchNewController extends GetxController {
  final address = ''.obs;
  final addressList = [].obs;
  final addressController = TextEditingController();

  void getLiveLocation() async {
    address.value = await updateUserLocation();
  }
}
