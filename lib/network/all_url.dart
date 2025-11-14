import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

Future<http.Client> getHttpClient() async {
  final ioc = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) =>
        true;
  return IOClient(ioc);
}

class AllUrl {
  static const String baseUrl =
      "http://192.168.29.41/business_buddy/api/user/v1";
  // static const String baseUrl =
  //     "https://businessbuddy.deepmindsit.com/api/user/v1";

  static const String sendOtp = '$baseUrl/check_user';
  static const String verifyOtp = '$baseUrl/verify_user';
  static const String register = '$baseUrl/register_user';
  static const String categories = '$baseUrl/get_categories';
  static const String regBusiness = '$baseUrl/register_business';
  static const String explore = '$baseUrl/explore';
  static const String businessDetails = '$baseUrl/business_details';
  static const String myBusiness = '$baseUrl/my_businesses';
  static const String addBusiness = '$baseUrl/register_business';
  static const String addPost = '$baseUrl/add_business_post';
  static const String addOffer = '$baseUrl/add_business_offer';
  static const String postDetails = '$baseUrl/get_post_details';
  static const String offerDetails = '$baseUrl/get_offer_details';


}
