import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class VideoPlayerControllerX extends GetxController {
  final String url;

  VideoPlayerControllerX(this.url);

  late bool isYouTube;

  VideoPlayerController? videoController;
  ChewieController? chewieController;
  YoutubePlayerController? youtubeController;

  final isInitialized = false.obs;
  final isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    isYouTube = url.contains('youtube.com') || url.contains('youtu.be');
    _initialize();
  }

  Future<void> _initialize() async {
    if (isYouTube) {
      youtubeController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(url)!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          loop: true,
        ),
      );
      isInitialized.value = true;
    } else {
      videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await videoController!.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoController!,
        autoPlay: false,
        looping: true,
        showControls: false,
        allowFullScreen: false,
      );

      isInitialized.value = true;
      isPlaying.value = true;
    }
  }

  void togglePlayPause() {
    if (isYouTube) return;

    if (videoController!.value.isPlaying) {
      videoController!.pause();
      isPlaying.value = false;
    } else {
      videoController!.play();
      isPlaying.value = true;
    }
  }

  @override
  void onClose() {
    videoController?.dispose();
    chewieController?.dispose();
    youtubeController?.dispose();
    super.onClose();
  }
}
