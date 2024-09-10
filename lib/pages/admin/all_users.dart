import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vituras_health/models/detail_user.dart';
import 'package:vituras_health/pages/admin/common_widget.dart';
import 'package:vituras_health/utils/common_info.dart';
import 'package:http/http.dart' as http;

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  List<DetailUser> _users = [];
  List<DetailUser> _filteredUsers = [];
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final response =
        await http.get(Uri.parse('${CommonInfo.baseApiUrl}User/UserDetails'),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },);

    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body);
      setState(() {
        _users = userJson.map((json) => DetailUser.fromJson(json)).toList();
        _filteredUsers = _users;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  void _filterUsers(String query) {
    List<DetailUser> filteredList = _users.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.surname.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredUsers = filteredList;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _filteredUsers = _users;
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminCommanContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            iconSize: 30,
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.transparent,
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  onChanged: _filterUsers,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    focusColor: Color.fromARGB(0, 242, 242, 242),
                    hintText: 'Search...',
                    hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                    border: InputBorder.none,
                  ),
                )
              : const Text(
                  'All Users',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
          actions: [
            IconButton(
              icon: Icon(
                _isSearching ? Icons.close : Icons.search,
                color: Colors.white,
              ),
              onPressed: _toggleSearch,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 1,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child:
                                      Icon(Icons.person, color: Colors.white),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Text(
                                    '${user.name} ${user.surname}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Email: ${user.email}',
                              style:
                                  const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Phone: ${user.phoneNumber}',
                              style:
                                  const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Applications: ${user.applicationCount}',
                              style:
                                  const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
