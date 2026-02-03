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
    final globalMute = getIt<GlobalVideoMuteController>();

    return GetBuilder<VideoPlayerControllerX>(
      init: VideoPlayerControllerX(url, isSingleView),
      autoRemove: true,
      tag: url,
      // global: false,
      builder: (controller) {
        return Obx(() {
          if (!controller.isInitialized.value) {
            return Center(child: LoadingWidget(color: primaryColor));
          }

          Widget video = Stack(
            alignment: Alignment.center,
            children: [
              _buildVideo(controller),

              /// ▶ Play overlay
              if (isSingleView) VideoTimeline(controller: controller),
              if (isSingleView &&
                  !controller.isYouTube &&
                  !controller.isPlaying.value)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 30,
                    color: Colors.white,
                  ),
                ),

              if (!controller.isYouTube)
                /// 🔊 Global mute
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: globalMute.toggleMute,
                    child: Obx(() {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          globalMute.isMuted.value
                              ? Icons.volume_off
                              : Icons.volume_up,
                          color: Colors.white,
                          size: 18,
                        ),
                      );
                    }),
                  ),
                ),
            ],
          );

          /// ✅ ONLY wrap GestureDetector when controllers are NOT needed
          if (isSingleView) {
            video = GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: globalMute.isSingleView.value
                  ? controller.togglePlayPause
                  : null,
              // onTap: controller.togglePlayPause,
              child: video,
            );
          }

          return VisibilityDetector(
            key: Key('video-$url'),
            onVisibilityChanged: (info) {
              final visible = info.visibleFraction > 0.6;
              visible ? controller.play() : controller.pause();
            },
            child: video,
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
