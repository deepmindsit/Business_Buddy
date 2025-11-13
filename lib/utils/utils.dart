import 'package:businessbuddy/utils/exported_path.dart';

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  await launchUrl(launchUri);
}

void sendingMails(String mail) async {
  final Uri params = Uri(scheme: 'mailto', path: mail);
  var url = Uri.parse(params.toString());
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}


void openMap(double latitude, double longitude) async {
  final url =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await launchUrl(Uri.parse(url))) {
  } else {
    throw 'Could not launch $url';
  }
}

