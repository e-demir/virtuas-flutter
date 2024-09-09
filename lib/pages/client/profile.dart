import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/pages/client/change_password.dart';
import 'package:flutter_application_1/services/dataService.dart';
import 'package:flutter_application_1/utils/color_select.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({super.key, required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> futureUser;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          colors: [Color(0xffdce35b), Color(0xff45b649)],
          stops: [0, 1],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )
      
      
    );

  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser(widget.userId);
    futureUser.then((user) {
      emailController.text = user.email;
      nameController.text = user.name;
      surnameController.text = user.surname;
      phoneController.text = user.phoneNumber;

      phoneController.addListener(_setChanged);
    });
  }

  void _setChanged() {
    setState(() {
      _isChanged = true;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _boxDecoration,
        child: FutureBuilder<User>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return _buildProfileForm(snapshot.data!);
            } else {
              return const Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileForm(User user) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(        
        key: _formKey,
        children: <Widget>[
          SizedBox(height: 150),
          Text(
            'Profile',
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold

                    // fontWeight: FontWeight.bold,
                    ),
          ),
          SizedBox(height: 100),
          Row(            
            children: [
              Column(
                
                children: [
                  RawMaterialButton(
                    onPressed: () {},
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(1.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.person_2_sharp,
                      size: 25.0,
                      color: Colors.blueGrey,
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [                  
                  Text(nameController.text + " " + surnameController.text,
                style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white

                    // fontWeight: FontWeight.bold,
                    )),
                ],
              ),
            ],
          ),
          Row(            
            children: [
              Column(
                
                children: [
                  RawMaterialButton(
                    onPressed: () {},
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(1.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.mail_outlined,
                      size: 25.0,
                      color: Colors.blueGrey,
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [                  
                  Text(emailController.text, style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white

                    // fontWeight: FontWeight.bold,
                    )),
                ],
              ),
            ],
          ),
          Row(            
            children: [
              Column(
                
                children: [
                  RawMaterialButton(
                    onPressed: () {},
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(1.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.phone_in_talk_sharp,
                      size: 25.0,
                      color: Colors.blueGrey,
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [                  
                  Text(phoneController.text,
                  style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white

                    // fontWeight: FontWeight.bold,
                    )),
                ],
              ),
            ],
          ),         
          // const SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: _isChanged
          //       ? () {
          //           if (_formKey.currentState!.validate()) {
          //             User updatedUser = User(
          //               id: widget.userId,
          //               email: emailController.text,
          //               name: nameController.text,
          //               surname: surnameController.text,
          //               phoneNumber: phoneController.text,
          //             );
          //             updateUser(updatedUser).then((updatedUser) {
          //               ScaffoldMessenger.of(context).showSnackBar(
          //                 const SnackBar(
          //                     content: Text('Profile updated successfully')),
          //               );
          //               setState(() {
          //                 _isChanged = false;
          //               });
          //             }).catchError((error) {
          //               ScaffoldMessenger.of(context).showSnackBar(
          //                 const SnackBar(
          //                     content: Text('Failed to update profile')),
          //               );
          //             });
          //           }
          //         }
          //       : null,
          //   child: const Text('Save'),
          // ),
          
          
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangePasswordPage(),
              ));
            },
            child: const Text('Change Password'),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Add your logout logic here
              logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
