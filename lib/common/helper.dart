import '../utils/exported_path.dart';

final _feedController = getIt<FeedsController>();
// final _homeController = getIt<HomeController>();
bool isUserAuthenticated() {
  return getIt<DemoService>().isDemo;
}

Future<void> handleOfferLike(
  Map<String, dynamic> item,
  Future<void> Function() refresh,
) async {
  print('handleOfferLike');
  if (_feedController.isLikeProcessing.value) return;

  if (!isUserAuthenticated()) {
    ToastUtils.showLoginToast();
    return;
  }

  await _feedController.isLikeProcessing.runWithLoader(() async {
    await _toggleOfferLike(item, refresh);
  });
}

Future<void> _toggleOfferLike(
  Map<String, dynamic> item,
  Future<void> Function() refresh,
) async {
  print('item 1============>$item');
  final bool wasLiked = item['is_offer_liked'] ?? false;
  final int likeCount = int.tryParse(item['offer_likes_count'].toString()) ?? 0;

  try {
    if (wasLiked) {
      await _feedController.offerUnLikeBusiness(
        item['offer_liked_id'].toString(),
      );
      item['offer_likes_count'] = (likeCount - 1).clamp(0, 999999);
    } else {
      await _feedController.offerLikeBusiness(
        item['business_id'].toString(),
        item['id'].toString(),
      );
      item['offer_likes_count'] = likeCount + 1;
    }

    item['is_offer_liked'] = !wasLiked;
    await refresh();
  } catch (e) {
    debugPrint('Like error: $e');
    // Consider showing an error toast to the user
  }
}

///////////////////////////post like button/////////////////////////

Future<void> handleFeedLike(
  Map<String, dynamic> item,
  Future<void> Function() refresh,
) async {
  final postId = item['post_id'].toString();

  if (_feedController.isPostLikeLoading(postId)) return;

  // if (_feedController.isLikeProcessing.value) return;

  if (!isUserAuthenticated()) {
    ToastUtils.showLoginToast();
    return;
  }

  try {
    _feedController.setPostLikeLoading(postId, true);
    await _toggleFeedLike(item, refresh);
  } finally {
    _feedController.setPostLikeLoading(postId, false);
  }

  // await _feedController.isLikeProcessing.runWithLoader(() async {
  //   await _toggleFeedLike(item, refresh);
  // });
}

Future<void> _toggleFeedLike(
  Map<String, dynamic> item,
  Future<void> Function() refresh,
) async {
  final bool wasLiked = item['is_liked'] ?? false;
  final int likeCount = int.tryParse(item['likes_count'].toString()) ?? 0;
  print('item==========================>$item');
  try {
    if (wasLiked) {
      await _feedController.unLikeBusiness(item['liked_id'].toString());
      item['likes_count'] = (likeCount - 1).clamp(0, 999999);
    } else {
      await _feedController.likeBusiness(
        item['business_id'].toString(),
        item['post_id'].toString(),
      );
      item['likes_count'] = likeCount + 1;
    }

    item['is_liked'] = !wasLiked;
    await refresh();
  } catch (e) {
    handleError('Like error: $e');
    // Consider showing an error toast to the user
  }
}

void handleError(String error) {
  // Use proper logging in production
  debugPrint(error);
  // Consider integrating with a crash analytics service
}

void onWhatsApp(String phoneNumber) async {
  String phone = '91$phoneNumber'; // country code + number
  const String message = 'Hello, I am interested';

  final Uri url = Uri.parse(
    'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    Get.snackbar('Error', 'WhatsApp not installed');
  }
}
