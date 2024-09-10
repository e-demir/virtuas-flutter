import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vituras_health/utils/common_info.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.0, // Adjust height as needed
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff1d2b64), Color(0xfff8cdda)],
              stops: [0, 1],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Center(
            child: Text(
              'Change Password', // Adjust title as needed
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff1d2b64), Color(0xfff8cdda)],
            stops: [0, 0.5],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: RegistrationForm(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Successful')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Registration successful!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String initialCountry = 'TR'; // Initial selected country code

  Future<void> _register() async {
    String name = _nameController.text;
    String surname = _surnameController.text;
    String email = _emailController.text;
    String phone = _phoneNumberController.text;
    String password = _passwordController.text;

    // String apiUrl = 'https://localhost:7128/api/Auth/Register';

    
    String apiUrl = '${CommonInfo.baseApiUrl}Auth/Register';

    var postData = jsonEncode({
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
      'PhoneNumber': phone
    });

    // POST request
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'basic YXBweWtvOjE5MDM='
      },
      body: postData,
    );

    if (response.statusCode == 200) {
       ArtSweetAlert.show(
  context: context,
  artDialogArgs: ArtDialogArgs(
    type: ArtSweetAlertType.success,
    title: "Register Successfull!",
    text: 'Lets login and go',

  )
);


      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    } else {
      // Log error message
      print('Failed to make POST request.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 100),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _surnameController,
                decoration: const InputDecoration(
                  labelText: 'Surname',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter surname';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter email';
                  } else if (!isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              // InternationalPhoneNumberInput(
              //   onInputChanged: (PhoneNumber number) {
              //     print(number.phoneNumber); // handle phone number change
              //   },
              //   selectorConfig: SelectorConfig(
              //     selectorType: PhoneInputSelectorType.DIALOG,
              //   ),
              //   ignoreBlank: false,
              //   autoValidateMode: AutovalidateMode.disabled,
              //   selectorTextStyle: TextStyle(color: Colors.black),
              //   initialValue: PhoneNumber(isoCode: initialCountry),
              //   textFieldController: _phoneNumberController,
              //   formatInput: true,
              //   keyboardType: TextInputType.phone,
              //   onSaved: (PhoneNumber number) {
              //     print('On Saved: $number');
              //   },
              // ),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter phone number';
                  } else if (value.length > 30) {
                    return 'Phone number must be less than or equal to 30 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password (4 digits only)',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter password';
                  } else if (value.length != 4) {
                    return 'Password must be exactly 4 digits';
                  } else if (!isNumeric(value)) {
                    return 'Password must contain only numbers';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter confirm password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If all validations pass
                    _register();
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isNumeric(String value) {
    return int.tryParse(value) != null;
  }

  bool isValidEmail(String value) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(value);
  }
}
