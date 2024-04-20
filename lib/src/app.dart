import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:meteoapp/blocs/map_cubit/map_cubit.dart';
import 'package:meteoapp/blocs/notification_bloc/notification_bloc.dart';
import 'package:meteoapp/domain/api/api_constant.dart';
import 'package:meteoapp/blocs/cubit/date_picker.dart';
import 'package:meteoapp/domain/theme/app_theme_cubit.dart';
import 'package:meteoapp/domain/theme/theme_extention.dart';
import 'package:meteoapp/repositories/notification_repository.dart';
import 'package:meteoapp/repositories/warnings_repo.dart';
import 'package:meteoapp/repositories/forecast_api_provider.dart';
import 'package:meteoapp/src/pages/home_page/homepage_view.dart';
import 'package:meteoapp/blocs/auth_bloc/auth_bloc.dart';
import 'package:meteoapp/src/pages/map_page/location_repository.dart';
import 'package:meteoapp/src/pages/onboarding_page/nickname_page.dart';
import 'package:meteoapp/src/pages/warning_page/warnings_cubit.dart';
import '../blocs/location_bloc/location_bloc.dart';
import '../blocs/page_builder_bloc/page_builder_bloc.dart';
import '../blocs/weather_bloc/weather_bloc.dart';
import '../blocs/cubit/localizations_cubit.dart';
import '../domain/services/route_service.dart';

class MyApp extends StatelessWidget {
  final bool isFirstRun;
  const MyApp(
    this.isFirstRun, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PageBuilderBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => LocalizationCubit(),
        ),
        BlocProvider(
          create: (context) => NicknameCubit(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => LocationBloc()
            ..add(
              RequestLocationPermission(),
            ),
        ),
        BlocProvider(
          create: (context) => NotificationBloc()
            ..add(RequestPermissionEvent())
            ..add(InitializeNotificationEvent()),
        ),
        BlocProvider(
          create: (context) => MapCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
            create: (context) => WeatherBloc(
                  repository: ForecastApiProvider(),
                )),
        BlocProvider(
          create: (context) => DatePickerCubit(),
        ),
        BlocProvider(
          create: (context) => WarningCubit(
            warningRepository: WarningRepository(apiUrl: ApiConstants.apiUrl),
          ),
        )
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ForecastApiProvider>(
            create: ((context) => ForecastApiProvider()),
          ),
          RepositoryProvider<LocationRepository>(
            create: ((context) => LocationRepository.instance),
          ),
          RepositoryProvider<NotificationRepository>(
              create: ((context) => NotificationRepository())),
        ],
        child: BlocBuilder<LocalizationCubit, Locale>(
          builder: (context, locale) {
            return BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) {
                var theme =
                    state == ThemeMode.light || state == ThemeMode.system
                        ? AppThemes.daylightTheme
                        : AppThemes.moonlightTheme;

                bool isDarkMode =
                    Theme.of(context).brightness == Brightness.dark;

                return MaterialApp(
                  restorationScopeId: 'app',
                  theme: isDarkMode ? AppThemes.moonlightTheme : theme,
                  darkTheme: AppThemes.moonlightTheme,
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: const HomepageRouter(),
                  locale: locale,
                  initialRoute: isFirstRun
                      ? Routes.onBoarding
                      : auth.currentUser == null
                          ? Routes.auth
                          : Routes.home,
                  onGenerateRoute: RouterGenerator.generateRoutes,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
