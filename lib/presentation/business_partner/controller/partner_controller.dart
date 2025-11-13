import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class PartnerDataController extends GetxController {
  final data = [].obs;
  final isLoading = true.obs;
  final recTitle = TextEditingController();
  final location = TextEditingController();
  final invCapacity = TextEditingController();
  final invHistory = TextEditingController();
  final textController = TextEditingController();
  final invType = RxnString();
  final businessInterest = [].obs;
  final invTypes = ['I am Investor', 'I need Investment', 'Other'].obs;
  final selectedBusiness = [].obs;

  final partnerKey = GlobalKey<FormState>();
}
