import 'package:flutter/material.dart';
import 'package:api_week5/list_employee.dart';
import 'package:api_week5/add_employee.dart';
import 'package:api_week5/edit_employee.dart';
import 'package:api_week5/detail_employee.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Employee',
        home: const EmployeeList(),
        routes: {
          'employee_list': (context) => const EmployeeList(),
          'employee_form_add': (context) => const EmployeeFormAdd(),
          'employee_form_edit': (context) => const EmployeeFormEdit(),
          'employee_detail': (context) => const EmployeeDetail(),
        });
  }
}
