import 'package:flutter/material.dart';
import 'package:vituras_health/pages/admin/admin_landing.dart';
import 'package:vituras_health/pages/client/client_landing.dart';
import 'package:vituras_health/pages/client/register.dart';
import 'package:vituras_health/pages/clinic/clinic_landing.dart';
import 'package:vituras_health/pages/clinic/possible_customers.dart';

import 'package:vituras_health/pages/common/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WelcomePage extends StatelessWidget {
  final storage = const FlutterSecureStorage();

  WelcomePage({super.key});

  Future<String> isLoggedIn() async {
    String? loggedInRole = await storage.read(key: 'loggedInAs');
    if (loggedInRole == "admin") {
      return "admin";
    }
    if (loggedInRole == "clinic") {
      return "clinic";
    }
    if (loggedInRole == "client") {
      return "client";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          String? loggedInRole = snapshot.data;
          if (loggedInRole == "admin") {
            return const AdminPage(text: "Admin");
          }
          if (loggedInRole == "clinic") {
            return const ClinicLandingPage();
          }
          if (loggedInRole == "client") {
            return const ClientLandingPage();
          } else {
            return const LoginPage();
          }
        }
      },
    );
  }
}
