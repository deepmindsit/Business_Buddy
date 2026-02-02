import 'package:businessbuddy/utils/exported_path.dart';

class InstagramVideoPlayer extends StatelessWidget {
  final String url;
  final bool showController;
  final bool isSingleView;

  const InstagramVideoPlayer({
    super.key,
    required this.url,
    this.isSingleView = false,
    this.showController = true,
  });

  @override
  Widget build(BuildContext context) {
    final globalMute = getIt<GlobalVideoMuteController>();
    return GetBuilder<VideoPlayerControllerX>(
      init: VideoPlayerControllerX(url, showController),
      autoRemove: true,
      tag: url,
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
              if (!controller.isYouTube && !controller.isPlaying.value)
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
          if (!controller.showControllers) {
            video = GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: isSingleView ? controller.togglePlayPause : null,
              child: video,
            );
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
            child: video,

            // GestureDetector(
            //   onTap: isSingleView ? controller.togglePlayPause : null,
            //   child: Stack(
            //     alignment: Alignment.center,
            //     children: [
            //       _buildVideo(controller),
            //
            //       // / Play icon overlay (like Instagram)
            //       if (!controller.isYouTube && !controller.isPlaying.value)
            //         Container(
            //           decoration: BoxDecoration(
            //             color: Colors.grey.withValues(alpha: 0.4),
            //             shape: BoxShape.circle,
            //           ),
            //           padding: const EdgeInsets.all(4),
            //           child: const Icon(
            //             Icons.play_arrow,
            //             size: 30,
            //             color: Colors.white,
            //           ),
            //         ),
            //
            //       /// 🔊 GLOBAL MUTE BUTTON
            //       Positioned(
            //         top: 8,
            //         right: 8,
            //         child: GestureDetector(
            //           onTap: globalMute.toggleMute,
            //           child: Obx(() {
            //             return Container(
            //               decoration: BoxDecoration(
            //                 color: Colors.black.withValues(alpha: 0.4),
            //                 shape: BoxShape.circle,
            //               ),
            //               padding: const EdgeInsets.all(6),
            //               child: Icon(
            //                 globalMute.isMuted.value
            //                     ? Icons.volume_off
            //                     : Icons.volume_up,
            //                 color: Colors.white,
            //                 size: 18,
            //               ),
            //             );
            //           }),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
