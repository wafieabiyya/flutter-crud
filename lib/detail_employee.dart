//ignore_for_file: library_private_types_in_public_api,, non_constant_identifie
//ignore_for_file: prefer_interpolation_to_compose_strings
//ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

import 'package:api_week5/model/employee_model.dart';
import 'api/rest_api.dart';
import 'config/config.dart';

class EmployeeDetail extends StatefulWidget {
  const EmployeeDetail({super.key});

  @override
  State<EmployeeDetail> createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  DataService dataService = DataService();

  String profilePicture = '-';

  late ValueNotifier<int> _notifier;

  //Employee Data
  List<EmployeeModel> employee = [];

  selectIdEmployee(String id) async {
    List data = [];
    data = json.decode(
      await dataService.selectId(token, project, 'employee', appid, id),
    );
    employee = data.map((data) => EmployeeModel.fromJson(data)).toList();
    profilePicture = employee[0].profpict;
  }

  //To get employee info
  Future reloadDataEmployee(dynamic value) async {
    setState(() {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as List<String>;

      selectIdEmployee(arguments[0]);
    });
  }

  //Profile Picture
  File? image;
  String? imageProfile;

  Future pickImage(String id) async {
    try {
      var pickedFiles = await FilePicker.platform.pickFiles(withData: true);

      if (pickedFiles != null) {
        var response = await dataService.upload(
            token,
            project,
            pickedFiles.files.first.bytes!,
            pickedFiles.files.first.extension.toString());
        var file = jsonDecode(response);

        await dataService.updateId('profpict', file['file_name'], token,
            project, 'employee', appid, id);

        profilePicture = file['file_name'];

        //Trigger Change  valueNotifier
        _notifier.value++;
      }
    } on PlatformException catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  void initState() {
    //init value notifier
    _notifier = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Detail"),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => pickImage(args[0]),
              child: const Icon(
                Icons.camera_alt,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'employee_form_edit',
                    arguments: [employee[0].id]).then(reloadDataEmployee);
              },
              child: const Icon(
                Icons.edit,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Warning"),
                      content: const Text("Remove this data?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('CANCEL'),
                          onPressed: () {
                            // Close Dialog
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('REMOVE'),
                          onPressed: () async {
                            // Close Dialog
                            Navigator.of(context).pop();

                            bool response = await dataService.removeId(
                                token, project, 'employee', appid, args[0]);

                            if (response) {
                              Navigator.pop(context, true);
                            }
                          },
                        )
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                Icons.delete_outline,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: selectIdEmployee(args[0]),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              {
                return const Text('none');
              }
            case ConnectionState.waiting:
              {
                return const Center(child: CircularProgressIndicator());
              }
            case ConnectionState.active:
              {
                return const Text('Active');
              }
            case ConnectionState.done:
              {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}',
                      style: const TextStyle(color: Colors.red));
                } else {
                  return ListView(
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.blue),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                // Listen Value Notifier And Re-Build Widget
                                ValueListenableBuilder(
                                  valueListenable: _notifier,
                                  builder: (context, value, child) =>
                                      profilePicture == '-'
                                          ? const Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 130,
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.bottomCenter,
                                              child: CircleAvatar(
                                                radius: 80,
                                                backgroundImage: NetworkImage(
                                                  fileUri + profilePicture,
                                                ),
                                              ),
                                            ),
                                ),
                                InkWell(
                                  onTap: () => pickImage(args[0]),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 30.00,
                                      width: 30.0,
                                      margin: const EdgeInsets.only(
                                        left: 183.00,
                                        top: 10.00,
                                        right: 113.00,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(
                                          5.00,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    employee[0].gender,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].name),
                          subtitle: const Text(
                            "Name",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                              icon:
                                  const Icon(Icons.person, color: Colors.blue),
                              onPressed: () {}),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].email),
                          subtitle: const Text(
                            "Email",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                              icon: const Icon(Icons.email, color: Colors.blue),
                              onPressed: () {}),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].phone),
                          subtitle: const Text(
                            "Phone",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                              icon: const Icon(Icons.phone_iphone_outlined,
                                  color: Colors.blue),
                              onPressed: () {}),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].birthday),
                          subtitle: const Text(
                            "Birthday",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                              icon: const Icon(Icons.calendar_month_outlined,
                                  color: Colors.blue),
                              onPressed: () {}),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(employee[0].address),
                          subtitle: const Text(
                            "Address",
                            style: TextStyle(color: Colors.black54),
                          ),
                          leading: IconButton(
                              icon: const Icon(Icons.home,
                                  color: Color.fromARGB(255, 55, 90, 120)),
                              onPressed: () {}),
                        ),
                      ),
                    ],
                  );
                }
              }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }
}
