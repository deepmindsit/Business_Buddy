import 'dart:io';

import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class ProfileController extends GetxController {
  final profileImage = Rx<File?>(null);
  final nameCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final educationCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final specialization = ''.obs;

}
