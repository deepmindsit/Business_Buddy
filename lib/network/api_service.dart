import 'dart:io';
import 'package:businessbuddy/network/all_url.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part 'api_service.g.dart';

@RestApi()
@injectable
abstract class ApiService {
  @factoryMethod
  factory ApiService(Dio dio) = _ApiService;

  @POST(AllUrl.sendOtp)
  Future<dynamic> sendOtp(@Part(name: "mobile_number") String number);

  @POST(AllUrl.verifyOtp)
  Future<dynamic> verifyOtp(
    @Part(name: "mobile_number") String number,
    @Part(name: "otp") String otp,
  );

  @POST(AllUrl.register)
  @MultiPart()
  Future<dynamic> register(
    @Part(name: "mobile_number") String emailOrPhone,
    @Part(name: "name") String name,
    @Part(name: "email_id") String email, {
    @Part(name: 'profile_image') File? profileImage,
  });

  @POST(AllUrl.addBusiness)
  @MultiPart()
  Future<dynamic> addBusiness(
    @Part(name: "user_id") String? userId,
    @Part(name: "name") String? name,
    @Part(name: "address") String? address,
    @Part(name: "mobile_number") String? mobileNumber,
    @Part(name: "category_id") String? categoryId,
    @Part(name: "about_business") String? aboutBusiness,
    @Part(name: "lat_long") String? latLong,
    @Part(name: "referral_code") String? referralCode, {
    @Part(name: 'image') File? profileImage,
    @Part(name: "attachments[]") List<MultipartFile>? attachment,
  });

  @POST(AllUrl.categories)
  Future<dynamic> getCategories();

  @POST(AllUrl.explore)
  Future<dynamic> explore(
    @Part(name: "category_id") String? catId,
    @Part(name: "lat_long") String? latLong,
  );

  @POST(AllUrl.businessDetails)
  Future<dynamic> businessDetails(
    @Part(name: "business_id") String? catId,
    @Part(name: "lat_long") String? latLong,
  );

  @POST(AllUrl.myBusiness)
  Future<dynamic> myBusiness(@Part(name: "user_id") String? userId);

  @POST(AllUrl.addPost)
  @MultiPart()
  Future<dynamic> addPost(
    @Part(name: "user_id") String userId,
    @Part(name: "business_id") String businessId,
    @Part(name: "details") String details, {
    @Part(name: 'image') File? profileImage,
  });

  @POST(AllUrl.newsDetails)
  Future<dynamic> newsDetails(
    @Part(name: "news_id") String newsId,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.newsByCategory)
  Future<dynamic> newsByCategory(
    @Part(name: "category_id") String categoryId,
    @Part(name: "page") String page,
    @Part(name: "per_page") String perPage,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.newsByTag)
  Future<dynamic> newsByTag(
    @Part(name: "tag_id") String categoryId,
    @Part(name: "page") String page,
    @Part(name: "per_page") String perPage,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.newsBySearch)
  Future<dynamic> newsBySearch(
    @Part(name: "keyword") String keyword,
    @Part(name: "page") String page,
    @Part(name: "per_page") String perPage,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.getProfile)
  Future<dynamic> getProfile(@Part(name: "user_id") String? userId);

  @POST(AllUrl.legalPage)
  Future<dynamic> legalPage(@Part(name: "page_slug") String? slug);

  @POST(AllUrl.deleteProfile)
  Future<dynamic> deleteProfile(@Part(name: "user_id") String? userId);

  @POST(AllUrl.getBookmarks)
  Future<dynamic> getBookmarks(
    @Part(name: "user_id") String? userId,
    @Part(name: "page") String page,
    @Part(name: "per_page") String perPage,
    @Part(name: "session_token") String token,
  );

  @POST(AllUrl.addBookmarks)
  Future<dynamic> addBookmarks(
    @Part(name: "news_id") String? newsId,
    @Part(name: "session_token") String token,
  );

  @POST(AllUrl.addBookmarks)
  Future<dynamic> removeBookmarks(
    @Part(name: "news_id") String? newsId,
    @Part(name: "session_token") String token,
    @Part(name: "action") String action,
  );

  @POST(AllUrl.addComment)
  Future<dynamic> addComment(
    @Part(name: "news_id") String? newsId,
    @Part(name: "session_token") String token,
    @Part(name: "content") String content,
  );

  @POST(AllUrl.editProfile)
  Future<dynamic> editProfile(
    @Part(name: "user_id") String? userId,
    @Part(name: "display_name") String name,
    @Part(name: "email") String email,
    @Part(name: "phone_number") String number,
  );

  @POST(AllUrl.updatePassword)
  Future<dynamic> updatePassword(
    @Part(name: "user_id") String? userId,
    @Part(name: "current_password") String currentPassword,
    @Part(name: "new_password") String newPassword,
    @Part(name: "confirm_password") String confirmPassword,
  );

  @POST(AllUrl.forgetPassword)
  Future<dynamic> forgetPassword(
    @Part(name: "email_or_phone") String emailOrPhone,
  );

  @POST(AllUrl.forgetVerifyOtp)
  Future<dynamic> forgetVerifyOtp(
    @Part(name: "email_or_phone") String emailOrPhone,
    @Part(name: "otp") String otp,
  );

  @POST(AllUrl.forgetPasswordReset)
  Future<dynamic> forgetPasswordReset(
    @Part(name: "email_or_phone") String emailOrPhone,
    @Part(name: "verification_token") String token,
    @Part(name: "new_password") String password,
  );

  @POST(AllUrl.updateFirebaseToken)
  Future<dynamic> updateFirebaseToken(
    @Part(name: "firebase_token") String token,
  );

  @POST(AllUrl.getNotification)
  Future<dynamic> getNotification(
    @Part(name: "page") String page,
    @Part(name: "per_page") String perPage,
  );

  // @POST(AllUrl.addFileComment)
  // @MultiPart()
  // Future<dynamic> addFileComment(
  //   @Part(name: "user_id") String userId,
  //   @Part(name: "file_id") String fileId,
  //   @Part(name: "status_id") String statusId,
  //   @Part(name: "description") String description, {
  //   @Part(name: 'attachments[]') List<MultipartFile>? attachment,
  // });
}

//
// @GET("/comments")
// @Headers(<String, dynamic>{ //Static header
//   "Content-Type" : "application/json",
//   "Custom-Header" : "Your header"
// })
// Future<List<Comment>> getAllComments();

// @Path- To update the URL dynamically replacement block surrounded by { } must be annotated with @Path using the same string.
// @Body- Sends dart object as the request body.
// @Query- used to append the URL.
// @Headers- to pass the headers dynamically.
