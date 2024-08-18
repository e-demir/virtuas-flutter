import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/credit_history.dart';
import 'package:flutter_application_1/utils/common_info.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/pages/admin/common_widget.dart'; // Bu dosyayı da eklediğinizden emin olun

class ClinicHistoryPage extends StatefulWidget {
  final int id;
  final String clinicTitle;

  const ClinicHistoryPage(
      {super.key, required this.id, required this.clinicTitle});

  @override
  State<ClinicHistoryPage> createState() => _ClinicHistoryPageState();
}

class _ClinicHistoryPageState extends State<ClinicHistoryPage> {
  late Future<List<CreditHistory>> _futureCreditHistory;

  Future<List<CreditHistory>> fetchCreditHistory() async {
    final response = await http.get(Uri.parse(
        '${CommonInfo.baseApiUrl}Clinics/GetCreditHistoryss?clinicId=${widget.id}'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => CreditHistory.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load credit history');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureCreditHistory = fetchCreditHistory();
  }

  @override
  Widget build(BuildContext context) {
    return AdminCommanContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AdminAppBar(
          label: 'Credit History',
        ),
        body: FutureBuilder<List<CreditHistory>>(
          future: _futureCreditHistory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No credit history found.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  CreditHistory history = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      // Ekstra aksiyonlar ekleyebilirsiniz
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
                                'Clinic Title: ${widget.clinicTitle}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Toplam Kredi miktarı: ${history.credit}',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Eklenen veya Kullanılan miktar: ${history.addCredit}',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              if (history.previousCredit != null)
                                const SizedBox(height: 8),
                              Text(
                                'Bir önceki miktar: ${history.previousCredit}',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Date Added: ${history.dateAdded}',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
