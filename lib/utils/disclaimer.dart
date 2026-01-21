import 'package:businessbuddy/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisclaimerDialog extends StatelessWidget {
  DisclaimerDialog({super.key});
  final RxBool isChecked = false.obs;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Disclaimer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'This platform only facilitates business connections. '
              'All communications, agreements, and transactions are '
              'solely the responsibility of the users involved.\n\n'
              'We are not responsible for any loss, dispute, or legal '
              'issue arising from business interactions.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),

            /// ✅ Checkbox
            Obx(
              () => Row(
                children: [
                  Checkbox(
                    activeColor: primaryColor,
                    side: BorderSide(color: Theme.of(context).scaffoldBackgroundColor),
                    value: isChecked.value,
                    onChanged: (value) {
                      isChecked.value = value ?? false;
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'I have read and agree to the disclaimer',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor:  Theme.of(context).scaffoldBackgroundColor,
                      side: BorderSide(color: primaryColor),
                    ),
                    onPressed: () => Get.back(result: false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: isChecked.value
                          ? () => Get.back(result: true)
                          : null, // disables button
                      child: const Text('I Agree'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
