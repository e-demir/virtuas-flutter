import 'package:flutter/material.dart';
import 'package:vituras_health/pages/admin/add_clinic.dart';
import 'package:vituras_health/pages/admin/all_applications.dart';
import 'package:vituras_health/pages/admin/all_users.dart';
import 'package:vituras_health/pages/admin/list_clinics.dart';
import 'package:vituras_health/pages/category/add_category.dart';
import 'package:vituras_health/pages/category/list_category.dart';
import 'package:vituras_health/services/dataService.dart';
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
                label: 'Admin Sayfası',
                size: 35,
                weight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
              const SizedBox(height: 80),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
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
                child: const Text("Çıkış Yap"),
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
          label: 'Klinik Ekle'),
      AdminPageButton(
        label: 'Klinik Listele',
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
          label: 'Kategori Ekle'),
      AdminPageButton(
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryListPage()),
            );
          },
          icon: Icons.list_rounded,
          label: 'Kategori Listele'),
      AdminPageButton(
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllUsers()),
            );
          },
          icon: Icons.supervised_user_circle_sharp,
          label: 'Kullanıcılar'),
      AdminPageButton(
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllApplicationsPage()),
            );
          },
          icon: Icons.verified_rounded,
          label: 'Başvurular')
    ];
    return buttons[index];
  }
}
