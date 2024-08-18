import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:flutter_application_1/pages/admin/admin_landing.dart';
import 'package:flutter_application_1/pages/admin/clinic_first_save.dart';
import 'package:flutter_application_1/pages/admin/common_widget.dart';
import 'package:flutter_application_1/services/dataService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddClinicPage extends StatefulWidget {
  const AddClinicPage({super.key});

  @override
  _AddClinicPageState createState() => _AddClinicPageState();
}

class _AddClinicPageState extends State<AddClinicPage> {
  final DataService _dataService = DataService();
  List<Category> categories = [];
  List<Category> selectedCategories = [];
  List<int> selectedCategoryIds = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _webAddressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataOnLoad();
  }

  void fetchDataOnLoad() async {
    List<Category> fetchedData = await _dataService.fetchCategories();
    setState(() {
      categories = fetchedData;
    });
  }

  Future<void> _addClinic() async {
    String clinicAddUrl = 'http://localhost:5241/api/clinics/add';
    var jsonData;
    var postData = jsonEncode({
      'title': _titleController.text,
      'description': _descriptionController.text,
      "address": _addressController.text,
      "webaddress": _webAddressController.text,
      "email": _emailController.text,
      "categories": selectedCategoryIds
    });

    var response = await http.post(
      Uri.parse(clinicAddUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: postData,
    );

    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
      String username = jsonData["username"];
      String password = jsonData["password"];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ClinicUserInfoPage(
                  username: username,
                  password: password,
                )),
      );
    } else {
      print('Failed to make POST request.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminCommanContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AdminAppBar(
          label: 'Add Clinic',
        ),
        body: Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 40),
                  AddTexfield(
                    textController: _titleController,
                    label: 'Title',
                    maxLenght: 20,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 12),
                  AddTexfield(
                    label: 'Description',
                    textController: _descriptionController,
                    maxLines: 2,
                    maxLenght: 200,
                  ),
                  const SizedBox(height: 12),
                  AddTexfield(
                      textController: _addressController,
                      label: 'Adress',
                      maxLenght: 200,
                      maxLines: 2),
                  const SizedBox(height: 12),
                  AddTexfield(
                      textController: _webAddressController,
                      label: 'Web Adress',
                      maxLenght: 50,
                      maxLines: 1),
                  const SizedBox(height: 12),
                  AddTexfield(
                      textController: _emailController,
                      label: 'Email for the clinic contact',
                      maxLenght: 50,
                      maxLines: 1),
                  const SizedBox(height: 30),
                  DropdownButtonFormField<Category>(
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(206, 224, 247, 251),
                          width: 1.0, // Alt çizgi kalınlığı (aktif)
                        ),
                      ),
                    ),
                    dropdownColor: Color.fromARGB(206, 224, 247, 251),
                    isExpanded: true,
                    hint: const Text(
                      'Select Categories',
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(206, 224, 247, 251)),
                    ),
                    value: null,
                    items: categories.map((Category category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(206, 197, 240, 247),
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            category.title,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 166, 95, 194),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (Category? selectedCategory) {
                      if (selectedCategory != null &&
                          !selectedCategories.contains(selectedCategory) &&
                          !selectedCategoryIds.contains(selectedCategory.id)) {
                        setState(() {
                          selectedCategories.add(selectedCategory);
                          selectedCategoryIds.add(selectedCategory.id);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: selectedCategories.map((Category category) {
                      return Chip(
                        label: Text(
                          category.title,
                          style: const TextStyle(
                              color: Color.fromARGB(206, 172, 101, 249)),
                        ),
                        onDeleted: () {
                          setState(() {
                            selectedCategories.remove(category);
                            selectedCategoryIds.remove(category.id);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addClinic,
                    child: const Text(
                      'Add Clinic',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
