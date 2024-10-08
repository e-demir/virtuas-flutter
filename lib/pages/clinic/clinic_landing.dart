import 'package:flutter/material.dart';
import 'package:vituras_health/pages/clinic/clinic_info.dart';
import 'package:vituras_health/pages/clinic/clinic_services.dart';
import 'package:vituras_health/pages/clinic/possible_customers.dart';
import 'package:vituras_health/pages/clinic/sent_offers.dart';
import 'package:vituras_health/services/dataService.dart';
import 'package:vituras_health/utils/color_select.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import your actual screens

class ClinicLandingPage extends StatefulWidget {
  const ClinicLandingPage({
    Key? key,
  }) : super(key: key);

  @override
  _ClinicLandingPageState createState() => _ClinicLandingPageState();
}

class _ClinicLandingPageState extends State<ClinicLandingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.index = 0; 
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return RawMaterialButton(
                child: const Icon(
                    size: 40.0, color: ColorSelect.secondary, Icons.menu_sharp),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          actions: <Widget>[
            RawMaterialButton(
              onPressed: () {},
              fillColor: ColorSelect.secondary,
              padding: const EdgeInsets.all(10.0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.person_2_sharp,
                size: 25.0,
                color: ColorSelect.background,
              ),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const SizedBox(
                height: 100.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: ColorSelect.secondary,
                  ),
                  child: Text(
                    'Vituras',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Possible customers'),
                onTap: () {
                  _tabController.index = 0;
                  Navigator.of(context).pop(); 
                },
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Services'),
                onTap: () {
                  _tabController.index = 1;
                  Navigator.of(context).pop(); 
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_back),
                title: const Text('Sent Offers'),
                onTap: () {
                  _tabController.index = 2;
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Clinic Info'),
                onTap: () {
                  _tabController.index = 3;
                  Navigator.of(context).pop();
                },
              ),
              const Divider(),
              const Spacer(), 
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () {
                  logout;                  
                  Navigator.of(context).pop();                   
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            const PossibleClientPreDataScreen(),
            ClinicServicesPage(),
            const SentOffersPage(),
            ClinicInfoPage()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
