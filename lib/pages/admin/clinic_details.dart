import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:flutter_application_1/models/clinic.dart';
import 'package:flutter_application_1/pages/admin/clinic_add_credit.dart';
import 'package:flutter_application_1/pages/admin/clinic_credit_history.dart';
import 'package:flutter_application_1/pages/admin/common_widget.dart';
import 'package:flutter_application_1/services/dataService.dart';

class ClinicDetailPage extends StatefulWidget {
  final Clinic clinic;

  const ClinicDetailPage({super.key, required this.clinic});

  @override
  _ClinicDetailPageState createState() => _ClinicDetailPageState();
}

class _ClinicDetailPageState extends State<ClinicDetailPage> {
  final DataService _dataService = DataService();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController addressController;
  late TextEditingController webAddressController;
  List<Category> selectedCategoires = [];
  List<Category> allCategories = [];

  bool isUpdated = false;

  @override
  void initState() {
    super.initState();
    getSelectedClinics();
    getAllClinicsOnLoad();
    titleController = TextEditingController(text: widget.clinic.title);
    descriptionController =
        TextEditingController(text: widget.clinic.description);
    addressController = TextEditingController(text: widget.clinic.address);
    webAddressController =
        TextEditingController(text: widget.clinic.webAddress);

    titleController.addListener(_checkIfUpdated);
    descriptionController.addListener(_checkIfUpdated);
    addressController.addListener(_checkIfUpdated);
    webAddressController.addListener(_checkIfUpdated);
  }

  void getAllClinicsOnLoad() async {
    List<Category> fetchedData = await _dataService.fetchCategories();
    setState(() {
      allCategories = fetchedData;
    });
  }

  void getSelectedClinics() async {
    List<Category> fetchedData =
        await _dataService.fetchSelectedCategoriesByClinicId(widget.clinic.id);
    setState(() {
      selectedCategoires = fetchedData;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    webAddressController.dispose();
    super.dispose();
  }

  void _checkIfUpdated() {
    setState(() {
      isUpdated = titleController.text != widget.clinic.title ||
          descriptionController.text != widget.clinic.description ||
          addressController.text != widget.clinic.address ||
          webAddressController.text != widget.clinic.webAddress;
    });
  }

  void saveClinic() {
    editClinic(Clinic(
        id: widget.clinic.id,
        title: titleController.text,
        description: descriptionController.text,
        address: addressController.text,
        webAddress: webAddressController.text,
        credit: 0,
        eMail: ""));
  }

  void _deleteClinic() {
    deleteClinic(widget.clinic.id);
  }

  void goToAddCredit() {}

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('bu kliniği silmek isteğinize emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteClinic();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Clinic deleted successfully!')),
                );
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.of(context).pushReplacementNamed('/admin');
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminCommanContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AdminAppBar(
          label: 'Clinic Details',
          action: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: isUpdated
                  ? () {
                      saveClinic();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Clinic updated successfully!')),
                      );
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.of(context).pushReplacementNamed('/admin');
                      });
                    }
                  : null,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              AddTexfield(
                textController: titleController,
                label: 'Title',
              ),
              const SizedBox(height: 20),
              AddTexfield(
                textController: descriptionController,
                label: 'Description',
              ),
              const SizedBox(height: 20),
              AddTexfield(textController: addressController, label: 'Address'),
              const SizedBox(height: 20),
              AddTexfield(
                  textController: webAddressController, label: 'Web Address'),
              const SizedBox(height: 20),
              TextWidget(
                label: widget.clinic.credit.toString(),
                fontStyle: FontStyle.normal,
                size: 25,
                weight: FontWeight.w600,
              ),
              const SizedBox(
                height: 70,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                child: ElevatedButton(
                  onPressed: () => _showDeleteConfirmationDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delete',
                          style: TextStyle(
                              color: Color.fromARGB(255, 171, 65, 65),
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                        Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 171, 65, 65),
                        ),
                      ]),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddCreditPage(clinic: widget.clinic),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Token',
                        style: TextStyle(
                            color: Color.fromARGB(255, 78, 133, 178),
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.add_shopping_cart,
                          color: Color.fromARGB(255, 78, 133, 178))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClinicHistoryPage(
                          id: widget.clinic.id,
                          clinicTitle: widget.clinic.title),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Token History',
                        style: TextStyle(
                            color: Color.fromARGB(255, 25, 37, 48),
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.history,
                          color: Color.fromARGB(255, 25, 37, 48))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
