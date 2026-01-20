import 'package:businessbuddy/utils/exported_path.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  Map<String, dynamic> data = message.data;
  NotificationService().handleNotificationNavigation(data, '');
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService().init();
  await configureDependencies();
  Get.put(DeepLinkController());
  await getIt<DemoService>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();
    return ScreenUtilConfig.init(
      context: context,
      child: ToastificationWrapper(
        child: Obx(
          () => AnimatedTheme(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            data: themeController.isDark.value
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              initialBinding: InitialBindings(),
              builder: (context, child) {
                final mediaQueryData = MediaQuery.of(context);
                final textScaler = TextScaler.linear(
                  mediaQueryData.textScaler.scale(1.0).clamp(0.8, 1.0),
                );
                final newMediaQueryData = mediaQueryData.copyWith(
                  boldText: false,
                  textScaler: textScaler,
                );
                return MediaQuery(data: newMediaQueryData, child: child!);
              },
              title: 'BizYaari',
              initialRoute: Routes.splash,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              defaultTransition: Transition.fadeIn,
              transitionDuration: const Duration(milliseconds: 300),
              getPages: AppRoutes.routes,
              // home: IconTest(),
            ),
          ),
        ),
      ),
    );
  }
}
