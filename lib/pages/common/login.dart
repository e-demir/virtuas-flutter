import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:vituras_health/pages/common/renew_password.dart';
import 'package:vituras_health/utils/common_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient:LinearGradient(
          colors: [Color(0xff1d2b64), Color(0xfff8cdda)],
          stops: [0, 0.5],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )                              
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return; // Validate form

    String username = _usernameController.text;
    String password = _passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String apiUrl = '${CommonInfo.baseApiUrl}auth/login';
    var postData = jsonEncode({'username': username, 'password': password});

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: postData,
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var role = jsonData["role"];
        var clinicId = jsonData["clinicId"];
        var userId = jsonData["id"];

        if (role == 'admin') {
          await storage.write(key: 'loggedInAs', value: "admin");
          Navigator.pushReplacementNamed(context, '/admin');
        } else if (role == 'client') {
          await storage.write(key: 'loggedInAs', value: "client");
          await prefs.setInt("userId", userId);
          Navigator.pushReplacementNamed(context, '/clientLandingPage');
        } else if (role == 'clinic') {
          await storage.write(key: 'loggedInAs', value: "clinic");
          await prefs.setInt("clinicId", clinicId);
          Navigator.pushReplacementNamed(context, '/clinicLandingPage',
              arguments: {
                'clinicId': clinicId,
              });
        }
      } else if (response.statusCode == 401) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RenewPasswordPage(
              username: username,
            ),
          ),
        );
      } else {
         ArtSweetAlert.show(
  context: context,
  artDialogArgs: ArtDialogArgs(
    type: ArtSweetAlertType.danger,
    title: "Oopps!",
    text: response.body,

  ));
      }
    } catch (e) {
      print('Exception during login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 100),
                    const Text(
                      'Welcome to',
                      style: TextStyle(fontFamily: 'BadScript', fontSize: 30),
                    ),
                    const Text(
                      'Vituras',
                      style: TextStyle(fontFamily: 'ExoBlack', fontSize: 40),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Reach out to the best health services',
                      style: TextStyle(fontFamily: 'BadScript', fontSize: 30),
                    ),
                    const SizedBox(height: 50),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your Email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            _login();
          },
          child: const Text('Login'),
        ),
        const SizedBox(height: 8.0),
        const Text(
          'Or',
          style: TextStyle(fontSize: 16.0),
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: const Text('Register'),
        ),
        const SizedBox(height: 40.0), // Ensures buttons are at the bottom
      ],
    );
  }
}
