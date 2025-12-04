import '../../../utils/exported_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = getIt<SplashController>();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1));
      controller.expanded.value = true;

      final token = await LocalStorage.getString('auth_key');
      final isOnboarded = await LocalStorage.getBool('isOnboarded');

      bool isConnected = await InternetConnectionChecker.instance.hasConnection;

      if (isConnected) {
        token != null
            ? Get.offAllNamed(Routes.mainScreen)
            : isOnboarded == true
            ? Get.offAllNamed(Routes.login)
            : Get.offAllNamed(Routes.onboarding);
      } else {
        AllDialogs().noInternetDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Material(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedCrossFade(
                firstCurve: Curves.fastOutSlowIn,
                crossFadeState: !controller.expanded.value
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: controller.transitionDuration,
                firstChild: Container(),
                secondChild: _logoRemainder(),
                alignment: Alignment.centerLeft,
                sizeCurve: Curves.easeInOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoRemainder() {
    return Image.asset(Images.logoVert, width: Get.width * 0.6.h);
    // return Image.network('http://192.168.29.37/flutter_splash/public/uploads/splash/flutter_splash.gif', width: Get.width * 0.9.h);
  }
}
