import 'package:flutter/material.dart';

import '../services/route.dart';
import 'consts.dart';

import 'package:flutter/material.dart';

class AppThemes {
  static final daylightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.lightBlue.withOpacity(0.8),
      Colors.yellow.withOpacity(0.9),
    ],
  );

  static final moonlightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.indigo.withOpacity(0.8),
      Colors.blueGrey.withOpacity(0.9),
    ],
  );

  static const blackAndWhiteGradient = RadialGradient(
    center: Alignment.center,
    radius: 0.8,
    colors: [Colors.yellow, Colors.deepOrange],
  );

  static ThemeData buildBaseTheme({
    required Color primaryColor,
    required Color scaffoldBackgroundColor,
    required Color backgroundColor,
    required Color appBarColor,
    required Color iconColor,
    required TextStyle titleTextStyle,
    required TextTheme textTheme,
    required Brightness brightness,
    required ColorScheme colorScheme,
  }) {
    return ThemeData(
      brightness: brightness,
      visualDensity: const VisualDensity(vertical: 0.5, horizontal: 0.5),
      primarySwatch: const MaterialColor(
        0xFFF5E0C3,
        <int, Color>{
          50: Color(0x1aF5E0C3),
          100: Color(0xa1F5E0C3),
          200: Color(0xaaF5E0C3),
          300: Color(0xafF5E0C3),
          400: Color(0xffF5E0C3),
          500: Color(0xffEDD5B3),
          600: Color(0xffDec29b),
          700: Color(0xffC9A87C),
          800: Color(0xffB28E5E),
          900: Color(0xff936F3E)
        },
      ),
      primaryColor: primaryColor,
      primaryColorBrightness: brightness,
      primaryColorLight: const Color(0x1aF5E0C3),
      primaryColorDark: const Color(0xff936F3E),
      canvasColor: const Color(0xffE09E45),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardColor: appBarColor,
      colorScheme: colorScheme,
      dividerColor: const Color(0x1f6D42CE),
      focusColor: const Color(0x1aF5E0C3),
      hoverColor: const Color(0xffDec29b),
      highlightColor: const Color(0xff936F3E),
      splashColor: const Color(0xff457BE0),
      unselectedWidgetColor: Colors.grey.shade400,
      disabledColor: Colors.grey.shade200,
      buttonTheme: const ButtonThemeData(),
      toggleButtonsTheme: const ToggleButtonsThemeData(),
      buttonColor: const Color(0xff936F3E),
      secondaryHeaderColor: Colors.grey,
      backgroundColor: backgroundColor,
      dialogBackgroundColor: Colors.white,
      indicatorColor: const Color(0xff457BE0),
      hintColor: Colors.grey,
      errorColor: Colors.red,
      toggleableActiveColor: const Color(0xff6D42CE),
      textTheme: textTheme,
      primaryTextTheme: const TextTheme(),
      accentTextTheme: const TextTheme(),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.blue),
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(style: BorderStyle.solid, color: Colors.blue)),
      ),
      iconTheme: IconThemeData(color: iconColor),
      primaryIconTheme: const IconThemeData(),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static final daylightTheme = buildBaseTheme(
    primaryColor: Color(0xFF019688),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: AppColors.green,
    appBarColor: AppColors.lightAqua,
    iconColor: Colors.black,
    titleTextStyle: const TextStyle(
      color: Colors.black87,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
    textTheme: lightTextTheme,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        primary: Color(0xFF019688),
        secondary: Colors.deepOrange,
        tertiary: Colors.black,
        onTertiary: Colors.black),
  );

  static InputDecoration getInputDecoration(
      BuildContext context, String hintText, IconData icon) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return InputDecoration(
      hintText: hintText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: const OutlineInputBorder(),
      labelStyle: kCategory.copyWith(
        color: !isLightTheme ? Colors.black : Colors.white,
      ),
      hintStyle: kTitle.copyWith(
          color: isLightTheme ? Colors.black : Colors.white,
          fontWeight: FontWeight.w400),
      fillColor: isLightTheme ? Colors.black : Colors.white,
      icon: Icon(
        icon,
        color: !isLightTheme ? Colors.black : Colors.white,
      ),
    );
  }

  static final moonlightTheme = buildBaseTheme(
    primaryColor: const Color.fromARGB(255, 72, 30, 102),
    scaffoldBackgroundColor: Colors.black,
    backgroundColor: AppColors.green,
    iconColor: Colors.white,
    appBarColor: const Color.fromARGB(255, 72, 30, 102),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
    textTheme: darkTextTheme,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        primary: Colors.blue,
        secondary: Colors.black54,
        tertiary: Color.fromARGB(255, 72, 30, 102),
        onTertiary: Colors.white),
  );

  static final blackAndWhiteTheme = ThemeData.light().copyWith(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.black,
      textTheme: ButtonTextTheme.primary,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
  );
}

class AppColors {
  static const Color lightAqua = Color(0xFFB5FFE9);
  static const Color dustyRose = Color(0xFFCEABB1);
  static const Color lightAquaDuplicate = Color(0xFFB5FFE9);
  static const Color deepLavender = Color(0xFF8447FF);
  static const Color darkCoral = Color(0xFFA63446);
  static const Color goldenrod = Color(0xFFFCBA04);
  static const Color lightAquaDuplicate2 = Color(0xFFB5FFE9);

  // Additional meaningful colors
  static const Color lightBlue = Color(0xFFADD8E6);
  static const Color indigo = Color(0xFF4B0082);
  static const Color lavender = Color(0xFFE6E6FA);
  static const Color coral = Color(0xFFFF6F61);
  static const Color goldenrod2 = Color(0xFFDAA520);
  static const Color darkCyan = Color(0xFF008B8B);
  static const Color green = Color.fromARGB(255, 133, 145, 103);

  // Organized by hue
  static List<Color> get allColorsByHue => [
        lightBlue,
        lavender,
        dustyRose,
        coral,
        goldenrod2,
        indigo,
        darkCyan,
        deepLavender,
        darkCoral,
        goldenrod,
        lightAqua,
      ];
}
