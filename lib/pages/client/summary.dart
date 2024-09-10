import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:vituras_health/models/answer.dart';
import 'package:vituras_health/models/summary.dart';
import 'package:vituras_health/utils/common_info.dart';
import 'package:vituras_health/utils/common_style.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummaryPage extends StatefulWidget {
  final SummaryData summaryData;

  const SummaryPage({super.key, required this.summaryData});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ?? 0;
    });
  }

  Future<void> _getOffers() async {
    SummaryData data = widget.summaryData;
    int categoryId = data.category.id;
    Map<int, String> answers = data.answers;

    List<Answer> getAnswer = answers.entries.map((e) {
      return Answer(id: e.key, title: e.value, questionId: e.key);
    }).toList();

    // Convert to JSON format (just the list)
    List<Map<String, dynamic>> list = getAnswer.map((answer) => answer.toJson()).toList();
    String apiUrl = '${CommonInfo.baseApiUrl}Application/Add?userId=$userId&categoryId=$categoryId';

    var postData = jsonEncode(list);
    // Make POST request
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
    title: "Okay!",
    text: response.body
  )
);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed('/clientLandingPage');
      });
    } else {
      print('Failed to make POST request.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        flexibleSpace: Container(
          decoration: CommonStyle.boxDecoration,
          child: Center(
            child: Text(
              'Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: CommonStyle.boxDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Category Details Card
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Category Details:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Category Name: ${widget.summaryData.category.title}'),
                      const SizedBox(height: 8),
                      Text('Description: ${widget.summaryData.category.description}'),
                    ],
                  ),
                ),
              ),
              // Answers Summary Card
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Answers Summary:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 200, // Fixed height to limit the size of the ListView
                        child: ListView.builder(
                          itemCount: widget.summaryData.answers.length,
                          itemBuilder: (context, index) {
                            int questionId = widget.summaryData.answers.keys.elementAt(index);
                            String questionTitle = widget.summaryData.questions.elementAt(index).title;
                            String answer = widget.summaryData.answers.values.elementAt(index);
                            return ListTile(
                              title: Text(questionTitle),
                              subtitle: Text(answer),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
               Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Application Date',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())),
                    ],
                  ),
                ),
              ),
             
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => _getOffers(),
                    child: const Text('Get Best Offers'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
