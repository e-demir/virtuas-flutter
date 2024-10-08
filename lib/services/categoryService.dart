import 'dart:convert';
import 'package:vituras_health/models/add_category.dart';
import 'package:vituras_health/utils/common_info.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final String apiUrl = '${CommonInfo.baseApiUrl}Category/Get';

  Future<List<AddCategory>> getCategories() async {
    var response = await http.get(Uri.parse(apiUrl),
     headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => AddCategory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> updateCategory(AddCategory category) async {
    String apiUrl = '${CommonInfo.baseApiUrl}Category/Update';

    var jsonBody = jsonEncode({
      'id': category.id,
      'title': category.title,
      'description': category.description,
      'credit': category.credit,
      'questions': category.questions.map((x) => x.toJson()).toList()
    });

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      print('Category updated successfully!');
    } else {
      throw Exception('Failed to update category');
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    String apiUrl = '${CommonInfo.baseApiUrl}Category/Delete?id=$categoryId';

    var response = await http.delete(Uri.parse(apiUrl),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },);

    if (response.statusCode == 200) {
      print('Category deleted successfully!');
    } else {
      throw Exception('Failed to delete category');
    }
  }
}
