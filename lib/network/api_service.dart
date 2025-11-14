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

  @POST(AllUrl.addOffer)
  @MultiPart()
  Future<dynamic> addOffer(
    @Part(name: "user_id") String userId,
    @Part(name: "business_id") String businessId,
    @Part(name: "name") String name,
    @Part(name: "details") String details,
    @Part(name: "start_date") String startDate,
    @Part(name: "end_date") String endDate,
    @Part(name: "highlight_points[]") List<String> highlightPoints, {
    @Part(name: 'image') File? profileImage,
  });


  @POST(AllUrl.postDetails)
  Future<dynamic> postDetails(@Part(name: "post_id") String? postId);

  @POST(AllUrl.offerDetails)
  Future<dynamic> offerDetails(@Part(name: "offer_id") String? offerId);

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
