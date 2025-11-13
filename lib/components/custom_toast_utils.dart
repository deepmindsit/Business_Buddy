import '../utils/exported_path.dart';

class ToastUtils {
  static void showSuccessToast(String message, {String title = 'Success'}) {
    ToastUtils.showToast(
      title: title,
      description: message,
      type: ToastificationType.success,
      icon: Icons.check_circle,
    );
  }

  static void showErrorToast(String message, {String title = 'Error'}) {
    ToastUtils.showToast(
      title: title,
      description: message,
      type: ToastificationType.error,
      icon: Icons.error,
    );
  }

  static void showWarningToast(String message, {String title = 'Warning'}) {
    ToastUtils.showToast(
      title: title,
      description: message,
      type: ToastificationType.warning,
      icon: Icons.warning,
    );
  }

  static void showToast({
    required String title,
    String? description,
    ToastificationType type = ToastificationType.info,
    Duration duration = const Duration(seconds: 2),
    ToastificationStyle style = ToastificationStyle.minimal,
    Alignment alignment = Alignment.topCenter,
    IconData? icon,
  }) {
    toastification.show(
      title: Text(title),
      description: description != null ? Text(description) : null,
      type: type,
      style: style,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      alignment: alignment,
      autoCloseDuration: duration,
      icon: icon != null ? Icon(icon) : null,
    );
  }
}
