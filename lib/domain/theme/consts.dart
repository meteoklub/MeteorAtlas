import 'package:flutter/material.dart';
import 'package:meteoapp/domain/theme/theme_extention.dart';

class Spacers {
  static Widget widthBox(double length) {
    return SizedBox(width: length);
  }

  // Statická metoda pro vytvoření HeightBox
  static Widget heightBox(double length) {
    return SizedBox(height: length);
  }
}

// Colors
const kBackgroundColor = Color(0xff191720);
const kTextFieldFill = Color(0xff1E1C24);
// TextStyles
const kHeadline =
    TextStyle(fontSize: 34, letterSpacing: 1.2, fontFamily: "Chillax");
const kHeader =
    TextStyle(fontSize: 20, letterSpacing: 1.1, fontFamily: "BespokeSerif");

const kBodyText =
    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500);

const kButtonText = TextStyle(
    color: Colors.black87,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: "Excon");

const kSubtitle = TextStyle(
    color: Colors.black87,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    fontFamily: "Excon");

const kTitle = TextStyle(
    color: Colors.black87,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    fontFamily: "BespokeSerif");

const kBodyText2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontFamily: "Chillax");

const kContinueText = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontFamily: "Chillax");

const kCta = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontFamily: "Chillax");

const kUnselected = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontFamily: "Excon");

const kSelected = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    fontFamily: "Excon");

const kCategory = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontFamily: "Excon");
// Definice TextTheme a jeho rozšíření o vaše styly
TextTheme lightTextTheme = const TextTheme(
  displayLarge: kHeadline,
  displayMedium: kHeader,
  bodyLarge: kBodyText,
  labelLarge: kButtonText,
  titleMedium: kSubtitle,
  displaySmall: kTitle,
  bodyMedium: kBodyText2,
  headlineMedium: kContinueText,
  headlineSmall: kCta,
  titleLarge: kUnselected,
  labelSmall: kSelected,
  bodySmall: kCategory,
);
// Invert the colors for dark theme
TextTheme darkTextTheme = lightTextTheme.copyWith(
  displayLarge: kHeadline.copyWith(color: Colors.white),
  displayMedium: kHeader.copyWith(color: Colors.white),
  bodyLarge: kBodyText.copyWith(color: Colors.white),
  labelLarge: kButtonText.copyWith(color: Colors.white),
  titleMedium: kSubtitle.copyWith(color: Colors.white),
  displaySmall: kTitle.copyWith(color: Colors.white),
  bodyMedium: kBodyText2.copyWith(color: Colors.white),
  headlineMedium: kContinueText.copyWith(color: Colors.white),
  headlineSmall: kCta.copyWith(color: Colors.white),
  titleLarge: kUnselected.copyWith(color: Colors.white),
  labelSmall: kSelected.copyWith(color: Colors.white),
  bodySmall: kCategory.copyWith(color: Colors.white),
);
