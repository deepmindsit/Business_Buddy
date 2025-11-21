import 'package:businessbuddy/utils/exported_path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await getIt<DemoService>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilConfig.init(
      context: context,
      child: ToastificationWrapper(
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
          title: 'Business Buddy',
          // initialRoute: Routes.mainScreen,
          initialRoute: Routes.splash,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          ),
          getPages: AppRoutes.routes,
          // home: IconTest(),
        ),
      ),
    );
  }
}
