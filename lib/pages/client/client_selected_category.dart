import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/answer.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:flutter_application_1/models/question.dart';
import 'package:flutter_application_1/pages/client/summary.dart';
import 'package:flutter_application_1/services/categoryService.dart';
import 'package:flutter_application_1/services/dataService.dart'; // Assuming DataService contains deleteQuestionById
import 'package:flutter_application_1/models/summary.dart';
import 'package:flutter_application_1/utils/common_style.dart'; // Import your model

class CategoryDetailPage extends StatefulWidget {
  final Category? category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  List<Question> questions = [];
  Map<int, String> answers = {};
  List<Answer> answers2 = [];

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      fetchDataOnLoad();
    }
  }

  void fetchDataOnLoad() async {
    try {
      List<Question> fetchedData =
          await fetchQuestionsByCategoryId(widget.category!.id);
      setState(() {
        questions = fetchedData;
      });
    } catch (e) {
      // Handle error gracefully, e.g., show a snackbar or retry mechanism
      print('Error fetching data: $e');
    }
  }

  void deleteQuestion(int questionId) async {
    try {
      await CategoryService().deleteCategory(questionId); // Adjust as needed
      setState(() {
        questions.removeWhere((question) => question.id == questionId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question deleted successfully')),
      );
    } catch (e) {
      print('Error deleting question: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete question')),
      );
    }
  }

  void saveAndNavigateToSummaryPage() {
    SummaryData summaryData = SummaryData(
        category: widget.category!,
        answers: answers,
        questions: questions,
        answers2: answers2);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryPage(summaryData: summaryData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.0, // Adjust height as needed
        flexibleSpace: Container(
          decoration: CommonStyle.boxDecoration,
          child: Center(
            child: Text(
              'Application Info', // Adjust title as needed
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: CommonStyle.boxDecoration,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(         
          
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.category, color: Color(0xff1276ef), size: 30),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                widget.category?.title ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(widget.category?.description ?? 'No description'),
                        const SizedBox(height: 16),
                        if (questions.isNotEmpty) ...[
                          const Text(
                            'Questions:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var question in questions) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.question_answer, color: Color(0xff1276ef), size: 30),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              question.title,
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your answer here',
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            answers[question.id] = value;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ] else ...[
                          const Text('No questions available.'),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: saveAndNavigateToSummaryPage,
                    child: const Text('Save and View Summary'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
