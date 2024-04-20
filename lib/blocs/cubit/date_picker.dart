import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class DatePickerCubit extends HydratedCubit<DateTime> {
  DatePickerCubit() : super(DateTime(2021, 7, 25));

  void selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: state,
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    );

    if (pickedDate != null && pickedDate != state) {
      emit(pickedDate);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Selected: ${pickedDate.day}/${pickedDate.month}/${pickedDate.year}'),
      ));
    }
  }

  @override
  DateTime? fromJson(Map<String, dynamic> json) {
    final epochMillis = json['value'] as int?;
    return epochMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(epochMillis)
        : null;
  }

  @override
  Map<String, dynamic> toJson(DateTime? state) {
    return {'value': state?.millisecondsSinceEpoch};
  }
}
