import '../utils/exported_path.dart';

class AppbarPlain extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final List<Widget>? actions;
  final double? titleSpacing;
  final String title;
  final Color backgroundColor;

  const AppbarPlain({
    super.key,
    this.showBackButton = true,
    this.actions,
    required this.title,
    this.titleSpacing = 0,
    this.backgroundColor = Colors.white,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0XFFFF383C).withValues(alpha: 0.4),
              Colors.white.withValues(alpha: 0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      centerTitle: true,
      title: CustomText(
        title: title,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
      ),
    );

    //   AppBar(
    //   backgroundColor: Colors.white,
    //   surfaceTintColor: Colors.white,
    //   titleSpacing: titleSpacing,
    //   centerTitle: false,
    //   title: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16),
    //     child: Image.asset(Images.logo, width: Get.width * 0.5.w),
    //   ),
    //   leading: showBackButton
    //       ? IconButton(
    //           icon: const Icon(Icons.arrow_back),
    //           onPressed: () => Navigator.of(context).pop(),
    //         )
    //       : null,
    //   actions: actions,
    //   elevation: 0,
    // );
  }
}
