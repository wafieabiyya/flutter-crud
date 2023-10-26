import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:api_week5/model/employee_model.dart';

import 'api/rest_api.dart';
import 'config/config.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  EmployeeListState createState() => EmployeeListState();
}

class EmployeeListState extends State<EmployeeList> {
  final searchKeyword = TextEditingController();
  bool searchStatus = false;

  DataService dataService = DataService();

  List data = [];
  List<EmployeeModel> employee = [];

  List<EmployeeModel> searchData = [];
  List<EmployeeModel> searchDataPre = [];

  selectAllEmployee() async {
    data = jsonDecode(
        await dataService.selectAll(token, project, 'employee', appid));
    employee = data.map((data) => EmployeeModel.fromJson(data)).toList();

    //Refresh ui
    setState(() {
      employee = employee;
    });
  }

  void filteredEmployee(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      searchData = data.map((data) => EmployeeModel.fromJson(data)).toList();
    } else {
      searchDataPre = data.map((data) => EmployeeModel.fromJson(data)).toList();
      searchData = searchDataPre
          .where((user) =>
              user.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    //Refresh UI
    setState(() {
      employee = searchData;
    });
  }

  Future reloadDataEmployee(dynamic value) async {
    setState(() {
      selectAllEmployee();
    });
  }

  @override
  void initState() {
    selectAllEmployee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !searchStatus ? const Text("Employee List") : searchField(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'employee_form_add')
                    .then(reloadDataEmployee);
              },
              child: const Icon(
                Icons.add,
                size: 26.0,
              ),
            ),
          ),
          searchIcon(),
        ],
      ),
      body: ListView.builder(
        itemCount: employee.length,
        itemBuilder: (context, index) {
          final item = employee[index];

          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.birthday),
            onTap: () {
              Navigator.pushNamed(context, 'employee_detail',
                  arguments: [item.id]).then(reloadDataEmployee);
            },
          );
        },
      ),
    );
  }

  Widget searchIcon() {
    return !searchStatus
        ? Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  searchStatus = true;
                });
              },
              child: const Icon(
                Icons.search,
                size: 26.0,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  searchStatus = false;
                });
              },
              child: const Icon(
                Icons.close,
                size: 26.0,
              ),
            ),
          );
  }

  Widget searchField() {
    return TextField(
      controller: searchKeyword,
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white, fontSize: 20),
      textInputAction: TextInputAction.search,
      onChanged: (value) => filteredEmployee(value),
      decoration: const InputDecoration(
          hintText: 'Enter To search',
          hintStyle: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 20)),
    );
  }
}
