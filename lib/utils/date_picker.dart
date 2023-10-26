import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker {
  static void showDialogPicker(
      BuildContext context, TextEditingController birthday) {
    var date = DateTime.now();
    late Future<DateTime?> selectedDate;

    selectedDate = showDatePicker(
        context: context,
        initialDate: DateTime(date.year - 20, date.month, date.day),
        firstDate: DateTime(1980),
        lastDate: DateTime(date.year - 20, date.month, date.day),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light(),
            child: child!,
          );
        });

    selectedDate.then((value) {
      if (value == null) return;

      final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      final String formattedDate = dateFormat.format(value);
      birthday.text = formattedDate;
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }
}
