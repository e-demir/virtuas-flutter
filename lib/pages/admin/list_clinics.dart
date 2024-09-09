import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/clinic.dart';
import 'package:flutter_application_1/pages/admin/clinic_details.dart';
import 'package:flutter_application_1/pages/admin/common_widget.dart';
import 'package:flutter_application_1/services/dataService.dart'; // fetchClinics fonksiyonunu buraya import edin

class ClinicsPage extends StatefulWidget {
  const ClinicsPage({super.key});

  @override
  _ClinicsPageState createState() => _ClinicsPageState();
}

class _ClinicsPageState extends State<ClinicsPage> {
  late Future<List<Clinic>> futureClinics;
  List<Clinic> _clinics = [];
  List<Clinic> _filteredClinics = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureClinics = fetchClinics();
    futureClinics.then((clinics) {
      setState(() {
        _clinics = clinics;
        _filteredClinics = clinics;
      });
    });
  }

  void _filterClinics(String query) {
    List<Clinic> filteredList = _clinics.where((clinic) {
      return clinic.title.toLowerCase().contains(query.toLowerCase()) ||
          clinic.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredClinics = filteredList;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _filteredClinics = _clinics;
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminCommanContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            iconSize: 30,
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.transparent,
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  onChanged: _filterClinics,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    focusColor: Color.fromARGB(0, 242, 242, 242),
                    hintText: 'Search...',
                    hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                    border: InputBorder.none,
                  ),
                )
              : const Text(
                  'Clinics',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              iconSize: 30,
              color: Colors.white,
              onPressed: _toggleSearch,
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: FutureBuilder<List<Clinic>>(
              future: futureClinics,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: _filteredClinics.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClinicDetailPage(
                                  clinic: _filteredClinics[index]),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Card(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _filteredClinics[index].title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(
                                            255, 255, 255, 255)),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _filteredClinics[index].description,
                                    style: const TextStyle(
                                        color: Color.fromARGB(
                                            255, 255, 255, 255)),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                      _filteredClinics[index].credit.toString(),
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
