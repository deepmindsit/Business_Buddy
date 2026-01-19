import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisclaimerDialog extends StatelessWidget {
  DisclaimerDialog({super.key});
  final RxBool isChecked = false.obs;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
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
                    onPressed: () => Get.back(result: false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
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
