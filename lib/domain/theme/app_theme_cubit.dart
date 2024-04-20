import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';

// Definice událostí pro změnu tématu
enum ThemeEvent { toggleTheme, systemThemeChanged }

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  // This handles the restoration of the theme mode when the app is restarted.
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final theme = json['themeMode'];

    switch (theme) {
      case 'ThemeMode.system':
        return ThemeMode.system;
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  void setTheme(ThemeMode themeMode, {Brightness? brightness}) {
    emit(themeMode);
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {
      'themeMode': state.toString(),
    };
  }
}
