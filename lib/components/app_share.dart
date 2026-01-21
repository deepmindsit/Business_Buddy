import 'package:businessbuddy/utils/exported_path.dart';

enum ShareEntityType { post, offer }

class AppShare {
  static const String _baseUrl = AllUrl.base;

  /// Generate share link
  static String generateLink({
    required ShareEntityType type,
    required String id,
  }) {
    switch (type) {
      case ShareEntityType.post:
        return '$_baseUrl/app/post/$id';
      case ShareEntityType.offer:
        return '$_baseUrl/app/offer/$id';
    }
  }

  /// Share link
  static Future<void> share({
    required ShareEntityType type,
    required String id,
  }) async {
    final link = generateLink(type: type, id: id);

    await SharePlus.instance.share(ShareParams(text: link));
  }
}
