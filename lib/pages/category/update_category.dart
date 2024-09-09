import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/add_category.dart';
import 'package:flutter_application_1/models/question.dart';
import 'package:flutter_application_1/services/categoryService.dart';
import 'package:flutter_application_1/pages/admin/common_widget.dart';
import 'package:flutter_application_1/pages/category/comman_widget.dart';

class UpdateCategoryPage extends StatefulWidget {
  final AddCategory category; // Güncellenecek kategori

  const UpdateCategoryPage({Key? key, required this.category})
      : super(key: key);

  @override
  _UpdateCategoryPageState createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage> {
  final CategoryService categoryService = CategoryService();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _creditController;
  List<TextEditingController> _questionControllers = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.category.title);
    _descriptionController =
        TextEditingController(text: widget.category.description);
    _creditController =
        TextEditingController(text: widget.category.credit.toString());

    // Mevcut soruları kontrol etmek ve TextEditingController oluşturmak
    widget.category.questions.forEach((question) {
      _questionControllers.add(TextEditingController(text: question.title));
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _creditController.dispose();
    _questionControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _saveUpdatedCategory() async {
    List<Question> updatedQuestions = [];

    for (var i = 0; i < _questionControllers.length; i++) {
      // ID'yi kullanmıyoruz çünkü soruları sıfırdan ekleyeceğiz
      updatedQuestions.add(Question(
        id: 0, // ID'yi sıfır olarak bırakabilirsiniz, çünkü ID'ler API tarafından atanacak
        categoryId: widget.category.id,
        title: _questionControllers[i].text,
      ));
    }

    AddCategory updatedCategory = AddCategory(
      id: widget.category.id,
      title: _titleController.text,
      description: _descriptionController.text,
      credit: int.parse(_creditController.text),
      questions: updatedQuestions,
    );

    try {
      // API'ye güncellenmiş kategoriyi gönderin
      await categoryService.updateCategory(updatedCategory);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori başarıyla güncellendi!')),
      );
      Navigator.of(context).pop(); // Sayfayı kapat ve geri dön
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategori güncellenemedi: $e')),
      );
    }
  }

  void _addQuestion() {
    setState(() {
      if (_questionControllers.length < 5) {
        _questionControllers.add(TextEditingController());
      }
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questionControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminCommanContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AdminAppBar(
          label: 'Kategoriyi Güncelle',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              CategoryTexField(
                controller: _titleController,
                label: 'Başlık',
                maxLenght: 60,
              ),
              const SizedBox(height: 12.0),
              CategoryTexField(
                controller: _descriptionController,
                label: 'Açıklama',
                maxLenght: 200,
              ),
              const SizedBox(height: 12.0),
              CategoryTexField(
                controller: _creditController,
                label: 'Kredi',
                hintText: 'Max 100',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Sorular',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
              const SizedBox(height: 12.0),
              Column(
                children: List.generate(
                  _questionControllers.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            controller: _questionControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Soru ${index + 1}',
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(206, 224, 247, 251),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent.withOpacity(0.3),
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide: BorderSide(
                                  color: Colors.transparent.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle),
                          onPressed: () {
                            _removeQuestion(index);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              if (_questionControllers.length < 5)
                ElevatedButton(
                  onPressed: _addQuestion,
                  child: const Text('Soru Ekle'),
                ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: _saveUpdatedCategory,
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
