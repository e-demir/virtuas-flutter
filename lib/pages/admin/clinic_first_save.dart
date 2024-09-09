import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';


class ClinicUserInfoPage extends StatelessWidget {
  final String username;
  final String password;

  const ClinicUserInfoPage({super.key, 
    required this.username,
    required this.password,
  });

  void _copyToClipboard(String text) {
    FlutterClipboard.copy(text).then((_) {      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clinic User Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCopyRow('Username', username),
            const SizedBox(height: 8.0),
            _buildCopyRow('Password', password),
            const SizedBox(height: 16.0),
            const Text(
              'Password will be forced to be changed at first login.',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyRow(String label, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label: $text'),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            _copyToClipboard(text);
          },
        ),
      ],
    );
  }
}
