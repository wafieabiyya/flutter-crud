//ignore_for_file: prefer_interpolation_to_compose_strings
//ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'utils/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:api_week5/model/employee_model.dart';

import 'api/rest_api.dart';
import 'config/config.dart';

class EmployeeFormEdit extends StatefulWidget {
  const EmployeeFormEdit({super.key});

  @override
  State<EmployeeFormEdit> createState() => _EmployeeFormEditState();
}

class _EmployeeFormEditState extends State<EmployeeFormEdit> {
  DataService dataService = DataService();

  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final birthday = TextEditingController();
  final address = TextEditingController();
  String gender = 'Male';
  String profpic = '';
  String updateId = '';
  bool loadData = false;

  late Future<DateTime> selectedDate;
  String date = "-";

  List<EmployeeModel> employee = [];

  selectEmployeeId(String id) async {
    List data = [];
    data = jsonDecode(
        await dataService.selectId(token, project, "employee", appid, id));
    employee = data.map((data) => EmployeeModel.fromJson(data)).toList();

    setState(() {
      name.text = employee[0].name;
      birthday.text = employee[0].birthday;
      phone.text = employee[0].phone;
      email.text = employee[0].email;
      address.text = employee[0].address;
      gender = employee[0].gender;
      updateId = employee[0].id;
      profpic = employee[0].profpict;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as List<String>;

    if (loadData == false) {
      selectEmployeeId(arguments[0]);

      loadData = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Form Edit'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Form Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: name,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Full Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Gender'),
                value: gender,
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue!;
                  });
                },
                items: <String>['Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            //Form Birthday
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: birthday,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Birthday'),
                onTap: () {
                  DatePicker.showDialogPicker(context, birthday);
                },
              ),
            ),
            //Form Phone
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Phone',
                ),
              ),
            ),
            //Form Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email Addres',
                ),
              ),
            ),
            //Form Address
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: address,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                minLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Address',
                ),
              ),
            ),
            //Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                  ),
                  onPressed: () async {
                    bool updatedStatus = await dataService.updateId(
                      'name~phone~email~address~gender~birthday~profpic',
                      name.text +
                          '~' +
                          phone.text +
                          '~' +
                          email.text +
                          '~' +
                          address.text +
                          '~' +
                          gender +
                          '~' +
                          birthday.text +
                          '~' +
                          profpic,
                      token,
                      project,
                      'employee',
                      appid,
                      updateId,
                    );
                    if (updatedStatus) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //DatePicker
}
