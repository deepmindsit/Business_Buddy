import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

Future<http.Client> getHttpClient() async {
  final ioc = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) =>
        true;
  return IOClient(ioc);
}

const googleMapsApi = 'AIzaSyAvg-gpAbB2_lKgSIJ9tG6JqjGJFaVeXNc';

class AllUrl {
  // static const String baseUrl = "http://192.168.29.37/bizyaari/api/user/v1";
  static const String baseUrl =
      "https://businessbuddy.deepmindsit.com/api/user/v1";

  static const String sendOtp = '$baseUrl/check_user';
  static const String verifyOtp = '$baseUrl/verify_user';
  static const String register = '$baseUrl/register_user';
  static const String categories = '$baseUrl/get_categories';
  static const String regBusiness = '$baseUrl/register_business';
  static const String explore = '$baseUrl/explore';
  static const String businessDetails = '$baseUrl/business_details';
  static const String myBusinessDetails = '$baseUrl/my_business_details';
  static const String myBusiness = '$baseUrl/my_businesses';
  static const String addBusiness = '$baseUrl/register_business';
  static const String addPost = '$baseUrl/add_business_post';
  static const String addOffer = '$baseUrl/add_business_offer';
  static const String postDetails = '$baseUrl/get_post_details';
  static const String offerDetails = '$baseUrl/get_offer_details';
  static const String getFeeds = '$baseUrl/get_feeds';
  static const String getHome = '$baseUrl/home';
  static const String getSpecialOffer = '$baseUrl/get_special_offers';
  static const String businessReqList = '$baseUrl/business_requirement_list';
  static const String getWulf = '$baseUrl/get_wulf_list';
  static const String getCapacity = '$baseUrl/get_investment_capacity_list';
  static const String addBusinessReq = '$baseUrl/add_business_requirement';
  static const String getMyProfile = '$baseUrl/my_profile_details';
  static const String getFollowList = '$baseUrl/get_business_following_list';
  static const String getUserProfile = '$baseUrl/user_profile_details';
  static const String updateProfile = '$baseUrl/update_profile';
  static const String sendBusinessRequest =
      '$baseUrl/send_business_requirement_request';
  static const String getBusinessRequested =
      '$baseUrl/my_requested_business_requirements';
  static const String getBusinessReceived =
      '$baseUrl/my_received_business_requirement_requests';
  static const String acceptBusinessRequest =
      '$baseUrl/accept_business_requirement_request';
  static const String followBusiness = '$baseUrl/follow_business';
  static const String unfollowBusiness = '$baseUrl/unfollow_business';
  static const String likeBusiness = '$baseUrl/like_business_post';
  static const String unlikeBusiness = '$baseUrl/unlike_business_post';
  static const String addReview = '$baseUrl/add_review_rating';
  static const String addPostComment = '$baseUrl/add_business_post_comment';
  static const String chatList = '$baseUrl/get_chat_list';
  static const String getSingleChat = '$baseUrl/get_messages';
  static const String sendMsg = '$baseUrl/send_message';
  static const String initiateChat = '$baseUrl/initiate_chat';
  static const String globalSearch = '$baseUrl/global_search';
}
