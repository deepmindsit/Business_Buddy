// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:businessbuddy/network/api_service.dart' as _i889;
import 'package:businessbuddy/presentation/business_partner/controller/partner_controller.dart'
    as _i235;
import 'package:businessbuddy/presentation/home_screen/widget/business/controller/my_bussiness_controller.dart'
    as _i745;
import 'package:businessbuddy/presentation/home_screen/widget/explorer/controller/explorer_controller.dart'
    as _i481;
import 'package:businessbuddy/presentation/inbox/controller/inbox_controller.dart'
    as _i655;
import 'package:businessbuddy/presentation/navigation/controller/navigation_controller.dart'
    as _i445;
import 'package:businessbuddy/presentation/onboarding/controller/onboarding_controller.dart'
    as _i736;
import 'package:businessbuddy/presentation/onboarding/controller/splash_controller.dart'
    as _i446;
import 'package:businessbuddy/presentation/profile/controller/profile_controller.dart'
    as _i634;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i235.PartnerDataController>(
      () => _i235.PartnerDataController(),
    );
    gh.lazySingleton<_i745.LBOController>(() => _i745.LBOController());
    gh.lazySingleton<_i481.ExplorerController>(
      () => _i481.ExplorerController(),
    );
    gh.lazySingleton<_i655.InboxController>(() => _i655.InboxController());
    gh.lazySingleton<_i445.NavigationController>(
      () => _i445.NavigationController(),
    );
    gh.lazySingleton<_i736.OnboardingController>(
      () => _i736.OnboardingController(),
    );
    gh.lazySingleton<_i446.SplashController>(() => _i446.SplashController());
    gh.lazySingleton<_i634.ProfileController>(() => _i634.ProfileController());
    gh.factory<_i889.ApiService>(() => _i889.ApiService(gh<_i361.Dio>()));
    return this;
  }
}
