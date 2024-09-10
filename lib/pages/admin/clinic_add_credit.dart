import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vituras_health/models/clinic.dart';
import 'package:vituras_health/pages/admin/common_widget.dart';
import 'package:vituras_health/services/dataService.dart';
import 'dart:async';

class AddCreditPage extends StatefulWidget {
  final Clinic clinic;

  const AddCreditPage({super.key, required this.clinic});

  @override
  _AddCreditPageState createState() => _AddCreditPageState();
}

class _AddCreditPageState extends State<AddCreditPage> {
  final TextEditingController _creditController = TextEditingController();

  void _addCredit() {
    int? newCredit = int.tryParse(_creditController.text);
    if (newCredit != null) {
      setState(() {
        widget.clinic.credit += newCredit;
      });
      addCreditToclinic(widget.clinic.id, widget.clinic.credit, newCredit);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credit added successfully!')),
      );
      _creditController.clear(); // Giriş alanını temizle
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed('/admin');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credit amount!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminCommanContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AdminAppBar(
          label: 'Add Credit to Clinic',
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            // Kartın arka plan rengi
            borderRadius: BorderRadius.circular(8.0), // Kenar yuvarlama
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clinic Name: ${widget.clinic.title}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Existing Credit: ${widget.clinic.credit}',
                style: const TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _creditController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Enter credit to Add / Remove',
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent.withOpacity(0.3),
                      width: 1.0, // Alt çizgi kalınlığı (aktif)
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(2),
                    borderSide: BorderSide(
                      color: Colors.transparent.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addCredit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0), // İç boşluk
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Kenar yuvarlama
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
