import '../utils/exported_path.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final List<Widget>? actions;
  final double? titleSpacing;
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    this.showBackButton = true,
    this.actions,
    this.titleSpacing = 0,
    this.backgroundColor = Colors.white,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      titleSpacing: titleSpacing,
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 16),
        child: Image.asset(Images.logo, width: Get.width * 0.5.w),
      ),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      actions: actions,
      elevation: 0,
    );
  }
}
