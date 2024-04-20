import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class LocalizationCubit extends HydratedCubit<Locale> {
  LocalizationCubit() : super(const Locale('en'));

  void updateLocale(Locale locale) => emit(locale);

  // This handles the restoration of the locale when the app is restarted.
  @override
  Locale? fromJson(Map<String, dynamic> json) {
    final languageCode = json['languageCode'];
    final countryCode = json['countryCode'];
    return Locale(languageCode, countryCode);
  }

  // This stores the Locale anytime it's changed
  @override
  Map<String, dynamic>? toJson(Locale state) {
    return {
      'languageCode': state.languageCode,
      'countryCode': state.countryCode,
    };
  }
}
