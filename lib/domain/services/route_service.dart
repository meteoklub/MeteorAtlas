import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteoapp/domain/services/route.dart';
import 'package:meteoapp/src/pages/atlas_page.dart';
import 'package:meteoapp/src/pages/home_page/home_view.dart';
import 'package:meteoapp/src/pages/login_page/choose_auth_page.dart';
import 'package:meteoapp/src/pages/login_page/login_page.dart';
import 'package:meteoapp/src/pages/map_page/map_page.dart';
import 'package:meteoapp/src/pages/onboarding_page/nickname_page.dart';
import 'package:meteoapp/src/pages/warning_page/warning_page.dart';
import 'package:meteoapp/src/pages/weather_page/weather_page.dart';
import 'package:meteoapp/src/pages/settings_page/settings_page.dart';

import '../../blocs/location_bloc/location_bloc.dart';
import '../../src/pages/home_page/homepage_view.dart';
import '../../src/pages/onboarding_page/onboarding.dart';

class Routes {
  static const onBoarding = "/onboarding";
  static const home = "/";
  static const auth = '/auth';
  static const login = '/login';
  static const register = '/register';
  static const settings = '/settings';
  static const weatherList = '/weatherList';
  static const warnings = '/warnings';
  static const map = '/map';
  static const atlas = '/atlas';
  static const nickname = "/nickname";
}

class RouterGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoarding:
        return CustomPageRoute(
          builder: ((context) => const OnboardingPage()),
        );
      case Routes.home:
        return CustomPageRoute(
          builder: ((context) => const HomePage()),
        );
      case Routes.login:
        return CustomPageRoute(
          builder: ((context) => const LoginPage()),
        );
      case Routes.map:
        return CustomPageRoute(
          builder: ((context) => const MapPage()),
        );
      case Routes.register:
        return CustomPageRoute(
          builder: ((context) => const LoginPage(
                isRegister: true,
              )),
        );
      case Routes.settings:
        return CustomPageRoute(
          builder: ((context) => const SettingsScreen()),
        );
      case Routes.warnings:
        return CustomPageRoute(
          builder: ((context) => const WarningsPage()),
        );
      case Routes.nickname:
        return CustomPageRoute(
          builder: ((context) => const NicknamePage()),
        );
      case Routes.weatherList:
        return CustomPageRoute(
          builder: ((context) => const WeatherListPage()),
        );
      case Routes.atlas:
        return CustomPageRoute(
          builder: ((context) => const AtlasPage()),
        );
      case Routes.auth:
        return CustomPageRoute(
          builder: ((context) => const ChooseAuthPage()),
        );
      default:
        return CustomPageRoute(
          builder: ((context) => const HomepageRouter()),
        );
    }
  }
}
