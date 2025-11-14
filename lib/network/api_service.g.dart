// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<dynamic> sendOtp(String number) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('mobile_number', number));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.29.41/business_buddy/api/user/v1/check_user',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> verifyOtp(String number, String otp) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('mobile_number', number));
    _data.fields.add(MapEntry('otp', otp));
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.29.41/business_buddy/api/user/v1/verify_user',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> register(
    String emailOrPhone,
    String name,
    String email, {
    File? profileImage,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('mobile_number', emailOrPhone));
    _data.fields.add(MapEntry('name', name));
    _data.fields.add(MapEntry('email_id', email));
    if (profileImage != null) {
      if (profileImage != null) {
        _data.files.add(
          MapEntry(
            'profile_image',
            MultipartFile.fromFileSync(
              profileImage.path,
              filename: profileImage.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    final _options = _setStreamType<dynamic>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'http://192.168.29.41/business_buddy/api/user/v1/register_user',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> addBusiness(
    String? userId,
    String? name,
    String? address,
    String? mobileNumber,
    String? categoryId,
    String? aboutBusiness,
    String? latLong,
    String? referralCode, {
    File? profileImage,
    List<MultipartFile>? attachment,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    if (name != null) {
      _data.fields.add(MapEntry('name', name));
    }
    if (address != null) {
      _data.fields.add(MapEntry('address', address));
    }
    if (mobileNumber != null) {
      _data.fields.add(MapEntry('mobile_number', mobileNumber));
    }
    if (categoryId != null) {
      _data.fields.add(MapEntry('category_id', categoryId));
    }
    if (aboutBusiness != null) {
      _data.fields.add(MapEntry('about_business', aboutBusiness));
    }
    if (latLong != null) {
      _data.fields.add(MapEntry('lat_long', latLong));
    }
    if (referralCode != null) {
      _data.fields.add(MapEntry('referral_code', referralCode));
    }
    if (profileImage != null) {
      if (profileImage != null) {
        _data.files.add(
          MapEntry(
            'image',
            MultipartFile.fromFileSync(
              profileImage.path,
              filename: profileImage.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    if (attachment != null) {
      _data.files.addAll(attachment.map((i) => MapEntry('attachments[]', i)));
    }
    final _options = _setStreamType<dynamic>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'http://192.168.29.41/business_buddy/api/user/v1/register_business',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> getCategories() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.29.41/business_buddy/api/user/v1/get_categories',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> explore(String? catId, String? latLong) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (catId != null) {
      _data.fields.add(MapEntry('category_id', catId));
    }
    if (latLong != null) {
      _data.fields.add(MapEntry('lat_long', latLong));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.29.41/business_buddy/api/user/v1/explore',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> businessDetails(String? catId, String? latLong) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (catId != null) {
      _data.fields.add(MapEntry('business_id', catId));
    }
    if (latLong != null) {
      _data.fields.add(MapEntry('lat_long', latLong));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.29.41/business_buddy/api/user/v1/business_details',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> myBusiness(String? userId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('user_id', userId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.29.41/business_buddy/api/user/v1/my_businesses',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> addPost(
    String userId,
    String businessId,
    String details, {
    File? profileImage,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('user_id', userId));
    _data.fields.add(MapEntry('business_id', businessId));
    _data.fields.add(MapEntry('details', details));
    if (profileImage != null) {
      if (profileImage != null) {
        _data.files.add(
          MapEntry(
            'image',
            MultipartFile.fromFileSync(
              profileImage.path,
              filename: profileImage.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    final _options = _setStreamType<dynamic>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'http://192.168.29.41/business_buddy/api/user/v1/add_business_post',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> addOffer(
    String userId,
    String businessId,
    String name,
    String details,
    String startDate,
    String endDate,
    List<String> highlightPoints, {
    File? profileImage,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('user_id', userId));
    _data.fields.add(MapEntry('business_id', businessId));
    _data.fields.add(MapEntry('name', name));
    _data.fields.add(MapEntry('details', details));
    _data.fields.add(MapEntry('start_date', startDate));
    _data.fields.add(MapEntry('end_date', endDate));
    highlightPoints.forEach((i) {
      _data.fields.add(MapEntry('highlight_points[]', i));
    });
    if (profileImage != null) {
      if (profileImage != null) {
        _data.files.add(
          MapEntry(
            'image',
            MultipartFile.fromFileSync(
              profileImage.path,
              filename: profileImage.path.split(Platform.pathSeparator).last,
            ),
          ),
        );
      }
    }
    final _options = _setStreamType<dynamic>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'http://192.168.29.41/business_buddy/api/user/v1/add_business_offer',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> postDetails(String? postId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (postId != null) {
      _data.fields.add(MapEntry('post_id', postId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.29.41/business_buddy/api/user/v1/get_post_details',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  @override
  Future<dynamic> offerDetails(String? offerId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (offerId != null) {
      _data.fields.add(MapEntry('offer_id', offerId));
    }
    final _options = _setStreamType<dynamic>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'http://192.168.29.41/business_buddy/api/user/v1/get_offer_details',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch(_options);
    final _value = _result.data;
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
