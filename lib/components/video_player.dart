import 'package:businessbuddy/utils/exported_path.dart';

class InstagramVideoPlayer extends StatelessWidget {
  final String url;
  final bool isSingleView;

  const InstagramVideoPlayer({
    super.key,
    required this.url,
    this.isSingleView = false,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoPlayerControllerX>(
      init: VideoPlayerControllerX(url),
      autoRemove: true,
      tag: url,
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
              onTap: isSingleView ? controller.togglePlayPause : null,
              child:
                  // _buildVideo(controller),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildVideo(controller),

                      // / Play icon overlay (like Instagram)
                      if (!controller.isYouTube && !controller.isPlaying.value)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
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
      child: SizedBox.expand(
        child: Chewie(
          key: ValueKey(controller.url),
          controller: controller.chewieController!,
        ),
      ),
    );
  }
}
