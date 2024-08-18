import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/admin/add_clinic.dart';
import 'package:flutter_application_1/pages/admin/all_applications.dart';
import 'package:flutter_application_1/pages/admin/all_users.dart';
import 'package:flutter_application_1/pages/admin/list_clinics.dart';
import 'package:flutter_application_1/pages/category/add_category.dart';
import 'package:flutter_application_1/pages/category/list_category.dart';
import 'package:flutter_application_1/pages/client/application_detail.dart';
import 'package:flutter_application_1/services/dataService.dart';
import 'common_widget.dart';

class AdminPage extends StatelessWidget {
  final String text;

  const AdminPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        child: AdminCommanContainer(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const TextWidget(
                label: 'Welcome Admin',
                size: 35,
                weight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: 6, // Number of items in the grid
                  itemBuilder: (context, index) {
                    return _buildGridItem(context, index);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("Logout"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    List<Widget> buttons = [
      AdminPageButton(
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddClinicPage()),
            );
          },
          icon: Icons.add_rounded,
          label: 'Add Clinic'),
      AdminPageButton(
        label: 'List Clinics',
        icon: Icons.list_alt_outlined,
        onPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClinicsPage()),
          );
        },
      ),
      AdminPageButton(
          onPress: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddCategoryPage()),
              ),
          icon: Icons.add_card_sharp,
          label: 'Add Category'),
      AdminPageButton(
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryListPage()),
            );
          },
          icon: Icons.list_rounded,
          label: 'List Categories'),
      AdminPageButton(
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllUsers()),
            );
          },
          icon: Icons.supervised_user_circle_sharp,
          label: 'All Users'),
      AdminPageButton(
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllApplicationsPage()),
            );
          },
          icon: Icons.verified_rounded,
          label: 'All Applications')
    ];
    return buttons[index];
  }
}
