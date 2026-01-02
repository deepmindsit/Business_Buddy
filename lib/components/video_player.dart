import 'package:businessbuddy/utils/exported_path.dart';

class InstagramVideoPlayer extends StatelessWidget {
  final String url;

  const InstagramVideoPlayer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoPlayerControllerX>(
      init: VideoPlayerControllerX(url),
      builder: (controller) {
        return Obx(() {
          if (!controller.isInitialized.value) {
            return Center(child: LoadingWidget(color: primaryColor));
          }

          return GestureDetector(
            onTap: controller.togglePlayPause,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildVideo(controller),

                /// Play icon overlay (like Instagram)
                if (!controller.isYouTube && !controller.isPlaying.value)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildVideo(VideoPlayerControllerX controller) {
    if (controller.isYouTube) {
      return YoutubePlayer(
        controller: controller.youtubeController!,
        showVideoProgressIndicator: true,
      );
    }

    return Chewie(controller: controller.chewieController!);
  }
}
