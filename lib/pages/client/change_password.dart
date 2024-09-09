import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/common_info.dart';
import 'package:flutter_application_1/utils/common_style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final newPassword = _newPasswordController.text;

    try {
      final response = await http.post(
        Uri.parse('${CommonInfo.baseApiUrl}Clinics/RenewPassword'),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },
        body: jsonEncode(<String, String>{
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.of(context).pop(); // Navigate back to the previous screen
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to change password')),
        );
      }
    } catch (e) {
      // Handle any errors that occur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const counterStyle = TextStyle(color: Colors.white,fontSize:15);
    const labelStyle = TextStyle(color: Colors.white,fontSize:20);
    return Scaffold(
       appBar: AppBar(
        toolbarHeight: 50.0, // Adjust height as needed
        flexibleSpace: Container(
          decoration: CommonStyle.boxDecoration ,
          child: Center(
            child: Text(
              'Change Password', // Adjust title as needed
              style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white

                    // fontWeight: FontWeight.bold,
                    )
            ),
          ),
        ),
      ),
      body: Container(
         decoration: CommonStyle.boxDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 100,),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    counterStyle: counterStyle, 
                    labelStyle: labelStyle),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length != 4) {
                      return 'New password must be 4 digits';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: false,
                  decoration: const InputDecoration(labelText: 'Confirm Password',
                  labelStyle: labelStyle,
                  counterStyle: counterStyle),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _changePassword,
                        child: const Text('Save'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
