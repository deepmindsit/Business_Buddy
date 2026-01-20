import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class VideoPlayerControllerX extends GetxController {
  final String url;

  VideoPlayerControllerX(this.url);

  late bool isYouTube;
  final isMuted = false.obs;
  VideoPlayerController? videoController;
  ChewieController? chewieController;
  YoutubePlayerController? youtubeController;

  final isInitialized = false.obs;
  final isPlaying = false.obs;
  final aspectR = (9 / 16).obs;

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
          mute: true,
          loop: true,
        ),
      );
      isInitialized.value = true;
    } else {
      videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await videoController!.initialize();
      // videoController!.pause();

      // ✅ ORIGINAL ASPECT RATIO
      aspectR.value = videoController!.value.aspectRatio;

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

  void pause() {
    if (isYouTube) {
      youtubeController?.pause();
    } else {
      videoController?.pause();
    }
    isPlaying.value = false;
  }

  void play() {
    if (isYouTube) {
      youtubeController?.play();
    } else {
      videoController?.play();
    }
    isPlaying.value = true;
  }

  /// 🔊 Toggle mute / unmute
  void toggleMute() {
    isMuted.toggle();

    if (isYouTube) {
      if (isMuted.value) {
        youtubeController?.mute();
      } else {
        youtubeController?.unMute();
      }
    } else {
      chewieController?.videoPlayerController.setVolume(isMuted.value ? 0 : 1);
    }
  }

  @override
  void onClose() {
    chewieController?.pause();
    videoController?.pause();

    chewieController?.dispose();
    videoController?.dispose();
    youtubeController?.dispose();

    super.onClose();
  }
}
