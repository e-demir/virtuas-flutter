import 'package:flutter/material.dart';
import 'package:vituras_health/models/applications_detail.dart';
import 'package:vituras_health/pages/client/application_detail.dart';
import 'package:vituras_health/services/dataService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  _ApplicationsPageState createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  Future<ApplicationDetailsResponse>? futureApplications;

  int? userId;
   final _boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          colors: [Color(0xffdce35b), Color(0xff45b649)],
          stops: [0, 1],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )
      
      
    );

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId') ?? 0;

    setState(() {
      futureApplications = fetchApplications(userId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    return Scaffold(
      body: Container(
        decoration: _boxDecoration,
        child: FutureBuilder<ApplicationDetailsResponse>(
          future: futureApplications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    Text(
                      'Applications',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold

                              // fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'See details of the applications.',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            snapshot.data?.applicationDetails?.length ?? 0,
                        itemBuilder: (context, index) {
                          var application =
                              snapshot.data!.applicationDetails![index];
                          var _labelStyle = TextStyle(
                              fontWeight: FontWeight.w200, fontSize: 15);
                          const _valueStyle = TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          );
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ApplicationDetailPage(
                                        application: application,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Category: ',
                                              style: _labelStyle,
                                            ),
                                            Text(
                                              '${application.categoryTitle}',
                                              style: _valueStyle,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'On: ',
                                              style: _labelStyle,
                                            ),
                                            Text(
                                              '${formatter.format(application.applicationDate!)}',
                                              style: _valueStyle,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Offers: ',
                                              style: _labelStyle,
                                            ),
                                            Text(
                                              '${application.offerCount}',
                                              style: _valueStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
