import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeService {
  static String formatDateTime(DateTime dateTime, {String locale = 'en'}) {
    final format = DateFormat.yMd(locale);
    return format.format(dateTime);
  }

  static String formatTimeOfDay(TimeOfDay timeOfDay, {String locale = 'en'}) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.Hm(locale);
    return format.format(dateTime);
  }

  static String parseFromSeconds(String seconds) {
    final datetime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(seconds) * 1000);
    return formatToDDMMYY(datetime);
  }

  static String formatDateTimeRange(DateTime start, DateTime end,
      {String locale = 'en'}) {
    final format = DateFormat.yMd(locale);
    final formattedStart = format.format(start);
    final formattedEnd = format.format(end);
    return '$formattedStart - $formattedEnd';
  }

  static String formatRangeToDDMMYY(DateTime start, DateTime end) {
    final formattedStart = formatToDDMMYY(start);
    final formattedEnd = formatToDDMMYY(end);
    return '$formattedStart - $formattedEnd';
  }

  static String formatToDDMMYY(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString().substring(2);
    final format = DateFormat('h:mm a', 'en');
    final formattedTime = format.format(dateTime);

    return '$day.$month.$year, $formattedTime';
  }
}
