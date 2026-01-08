import 'package:businessbuddy/utils/exported_path.dart';

class InstagramVideoPlayer extends StatelessWidget {
  final String url;

  const InstagramVideoPlayer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoPlayerControllerX>(
      init: VideoPlayerControllerX(url),
      tag: url, // ⭐ VERY IMPORTANT (unique per video)
      builder: (controller) {
        return Obx(() {
          if (!controller.isInitialized.value) {
            return Center(child: LoadingWidget(color: primaryColor));
          }

          return VisibilityDetector(
            key: Key('video-$url'),
            onVisibilityChanged: (info) {
              final visible = info.visibleFraction > 0.6;

              if (!visible) {
                controller.pause(); // ⛔ STOP audio
              } else {
                controller.play();
              }
            },
            child: GestureDetector(
              onTap: controller.togglePlayPause,
              child: _buildVideo(controller),

              // Stack(
              //   // alignment: Alignment.center,
              //   children: [
              //     _buildVideo(controller),
              //
              //     /// Play icon overlay (like Instagram)
              //     // if (!controller.isYouTube && !controller.isPlaying.value)
              //     //   Container(
              //     //     decoration: BoxDecoration(
              //     //       color: Colors.grey.withValues(alpha: 0.4),
              //     //       shape: BoxShape.circle,
              //     //     ),
              //     //     padding: const EdgeInsets.all(16),
              //     //     child: const Icon(
              //     //       Icons.play_arrow,
              //     //       size: 60,
              //     //       color: Colors.white,
              //     //     ),
              //     //   ),
              //   ],
              // ),
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

    return AspectRatio(
      aspectRatio: controller.aspectR.value,
      child: Chewie(controller: controller.chewieController!),
    );
  }
}
