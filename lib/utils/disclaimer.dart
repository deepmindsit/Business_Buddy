// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class DisclaimerDialog extends StatelessWidget {
//   const DisclaimerDialog({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 24),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Disclaimer',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               'This platform only facilitates business connections. '
//                   'All communications, agreements, and transactions are '
//                   'solely the responsibility of the users involved.\n\n'
//                   'We are not responsible for any loss, dispute, or legal '
//                   'issue arising from business interactions.',
//               style: TextStyle(fontSize: 14, height: 1.5),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       Get.back(); // Close app or dialog
//                     },
//                     child: const Text('Cancel'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Save consent here
//                       Get.back(result: true);
//                     },
//                     child: const Text('I Agree'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// @override
// void onInit() {
//   super.onInit();
//   showDisclaimerIfNeeded();
// }
//
//
// Future<bool> confirmDisclaimer() async {
//   final isAccepted = box.read('disclaimerAccepted') ?? false;
//
//   if (isAccepted) return true;
//
//   final result = await Get.dialog<bool>(
//     const DisclaimerDialog(),
//     barrierDismissible: false,
//   );
//
//   if (result == true) {
//     box.write('disclaimerAccepted', true);
//     return true;
//   }
//
//   return false;
// }
//
//
// onPressed: () async {
// final canProceed = await confirmDisclaimer();
// if (!canProceed) return;
//
// // Send business request
// }
//
//
//
// // Future<void> showDisclaimerIfNeeded() async {
// //   final isAccepted = box.read('disclaimerAccepted') ?? false;
// //
// //   if (!isAccepted) {
// //     final result = await Get.dialog<bool>(
// //       const DisclaimerDialog(),
// //       barrierDismissible: false,
// //     );
// //
// //     if (result == true) {
// //       box.write('disclaimerAccepted', true);
// //     }
// //   }
// // }
