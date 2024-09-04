import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/detail_application.dart';
import 'package:flutter_application_1/pages/admin/common_widget.dart';
import 'package:flutter_application_1/utils/common_info.dart';
import 'package:http/http.dart' as http;

class AllApplicationDetailPage extends StatelessWidget {
  final DetailApplication application;

  const AllApplicationDetailPage({Key? key, required this.application})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminCommanContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AdminAppBar(
          label: '${application.username} ${application.userSurname}',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Card(
                color: Colors.transparent,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Application Date: ${application.applicationDate}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        'Category Title: ${application.categoryTitle}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Answers:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8.0),
              ...application.answers.map((answer) {
                return Card(
                  color: Colors.transparent,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      answer.questionTitle,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: Text(answer.answerTitle,
                        style: const TextStyle(color: Colors.white)),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class AllApplicationsPage extends StatefulWidget {
  @override
  _AllApplicationsPageState createState() => _AllApplicationsPageState();
}

class _AllApplicationsPageState extends State<AllApplicationsPage> {
  List<DetailApplication> _applications = [];
  List<DetailApplication> _filteredApplications = [];
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    final response = await http.get(Uri.parse(
        '${CommonInfo.baseApiUrl}Application/GetAllApplicationsWithAnswers'),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },);

    if (response.statusCode == 200) {
      final List<dynamic> applicationJson = json.decode(response.body);
      setState(() {
        _applications = applicationJson
            .map((json) => DetailApplication.fromJson(json))
            .toList();
        _filteredApplications = _applications;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load applications');
    }
  }

  void _filterApplications(String query) {
    List<DetailApplication> filteredList = _applications.where((application) {
      return application.username.toLowerCase().contains(query.toLowerCase()) ||
          application.userSurname.toLowerCase().contains(query.toLowerCase()) ||
          application.categoryTitle.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredApplications = filteredList;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _filteredApplications = _applications;
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
                  onChanged: _filterApplications,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    focusColor: const Color.fromARGB(0, 242, 242, 242),
                    hintText: 'Search...',
                    hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                    border: InputBorder.none,
                  ),
                )
              : const Text(
                  'All Applications',
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
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _filteredApplications.length,
                itemBuilder: (context, index) {
                  final application = _filteredApplications[index];
                  return Container(
                    color: Colors.transparent,
                    child: Card(
                      color: Colors.transparent,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 1,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        title: Text(
                          '${application.username} ${application.userSurname}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20),
                        ),
                        subtitle: Text(
                          'Category: ${application.categoryTitle}',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllApplicationDetailPage(
                                  application: application),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
