// data_service.dart

import 'dart:convert';
import 'package:vituras_health/models/add_category.dart';
import 'package:vituras_health/models/applications_detail.dart';
import 'package:vituras_health/models/category.dart';
import 'package:vituras_health/models/client_data_response.dart';
import 'package:vituras_health/models/clinic.dart';
import 'package:vituras_health/models/possible_applications.dart';
import 'package:vituras_health/models/question.dart';
import 'package:vituras_health/models/user.dart';
import 'package:vituras_health/utils/common_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataService {
  final String categoryGetUrl = '${CommonInfo.baseApiUrl}Category/Get';

  Future<List<Category>> fetchCategories() async {
    List<Category> data = [];

    try {
      final response = await http.get(Uri.parse(categoryGetUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        data = jsonData.map((json) => Category.fromJson(json)).toList();
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading data: $e');
    }
    return data;
  }

  Future<List<Category>> fetchSelectedCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var clinicId = prefs.getInt('clinicId') as int;

    final response = await http.post(Uri.parse(
        '${CommonInfo.baseApiUrl}Category/GetByClinicId?clinicId=$clinicId'),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((cat) => Category.fromJson(cat)).toList();
    } else {
      throw Exception('Failed to load clinics');
    }
  }

  Future<List<Category>> fetchSelectedCategoriesByClinicId(int clinicId) async {
    final response = await http.post(Uri.parse(
        '${CommonInfo.baseApiUrl}Category/GetByClinicId?clinicId=$clinicId'),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((cat) => Category.fromJson(cat)).toList();
    } else {
      throw Exception('Failed to load clinics');
    }
  }

  Future<void> updateClinicCategoires(List<int> selectedCategoryIds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var clinicId = prefs.getInt('clinicId') as int;
    final String apiUrl =
        '${CommonInfo.baseApiUrl}Clinics/UpdateCategory?clinicId=$clinicId';

    final String body = jsonEncode(selectedCategoryIds);
    try {
      // Send a PUT request to the API
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },
        body: body, // Convert the request body to JSON
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // If the server returns an OK response, parse the response
        print('Categories updated successfully');
      } else {
        // If the server returns an error response, throw an exception
        throw Exception(
            'Failed to update categories: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error: $e');
    }
  }
}

Future<List<Question>> fetchQuestionsByCategoryId(int categoryId) async {
  List<Question> data = [];
  final String categoryGetUrl =
      '${CommonInfo.baseApiUrl}Question/GetByCategoryId?categoryId=$categoryId';

  try {
    final response = await http.get(Uri.parse(categoryGetUrl),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      data = jsonData.map((json) => Question.fromJson(json)).toList();
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error loading data: $e');
  }
  return data;
}

Future<void> editClinic(Clinic clinic) async {
  String apiUrl = '${CommonInfo.baseApiUrl}Clinics/Update';

  var postData = jsonEncode(({
    'id': clinic.id,
    'title': clinic.title,
    "description": clinic.description,
    "address": clinic.address,
    "webAddress": clinic.webAddress,
    "categories": []
  }));

  // POST isteği yapılıyor
  var response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },
    body: postData,
  );

  print("stop");
  // Başarılı giriş durumunda bir sonraki sayfaya yönlendirme (Navigator)
  // Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
}

Future<List<Clinic>> fetchClinics() async {
  final response =
      await http.get(Uri.parse('${CommonInfo.baseApiUrl}Clinics/Get'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },);

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((clinic) => Clinic.fromJson(clinic)).toList();
  } else {
    throw Exception('Failed to load clinics');
  }
}

Future<void> deleteClinic(int clinicId) async {
  final response = await http.delete(
      Uri.parse('${CommonInfo.baseApiUrl}Clinics/Delete?id=$clinicId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },);
  if (response.statusCode == 200) {
  } else {
    throw Exception('Failed to load clinics');
  }
}

Future<void> addCreditToclinic(int id, int clinisCredit, int addCredit) async {
  final response = await http.put(Uri.parse(
      '${CommonInfo.baseApiUrl}Clinics/AddCreditToClinic?clinicId=$id&clinicCredit=$clinisCredit&newCredit=$addCredit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },);
  if (response.statusCode == 200) {
  } else {
    throw Exception('Failed to load clinics');
  }
}

Future<ApplicationDetailsResponse> fetchApplications(int userId) async {
  final response = await http.get(Uri.parse(
      '${CommonInfo.baseApiUrl}Application/GetApplicationsWithAnswers?userId=$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },);

  if (response.statusCode == 200) {
    return ApplicationDetailsResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load applications');
  }
}

const String updateUserUrl = '${CommonInfo.baseApiUrl}User/Update';

Future<User> fetchUser(int userId) async {
  final response = await http.post(
    Uri.parse('${CommonInfo.baseApiUrl}User/Profile?userId=$userId'),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },
    body: jsonEncode({'userId': userId}),
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user');
  }
}

Future<User> updateUser(User user) async {
  final response = await http.post(
    Uri.parse(updateUserUrl),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },
    body: jsonEncode(user.toJson()),
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update user');
  }
}

Future<PossibleClientPreDataResponse> fetchApplicationsPreData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var x = prefs.getInt('clinicId') as int;

  final response = await http.get(Uri.parse(
      '${CommonInfo.baseApiUrl}Application/GetApplicationsPreData?clinicId=$x'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      }

      );

  if (response.statusCode == 200) {
    return PossibleClientPreDataResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load applications');
  }
}

Future<void> createCategory(AddCategory addCategory) async {
  // Örnek API URL
  String apiUrl = '${CommonInfo.baseApiUrl}Category/Add';

  try {
    // Kategori bilgilerini ve soruları JSON formatına çevir
    String jsonBody = jsonEncode({
      'id': addCategory.id,
      'title': addCategory.title,
      'description': addCategory.description,
      'credit': addCategory.credit,
      'questions':
          addCategory.questions.map((question) => question.toJson()).toList(),
    });

    // API'ye POST isteği gönder
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      // Başarılı bir şekilde kategori oluşturuldu
      print('Category created successfully!');
    } else {
      // Başarısız durumda hata mesajı al
      print('Failed to create category: ${response.statusCode}');
    }
  } catch (e) {
    // Hata durumunda hata mesajı yazdır
    print('Exception occurred: $e');
  }
}

Future<int?> getClinicCredit(int? clinicId) async {
  final response = await http.get(Uri.parse(
      '${CommonInfo.baseApiUrl}Clinics/GetCredit?clinicId=$clinicId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },
      );

  if (response.statusCode == 200) {
    return int.parse(response.body);
  } else {
    throw Exception('Failed to load applications');
  }
}

Future<int?> giveOffer(int? clinicId, int applicationId, int price) async {
  String apiUrl = '${CommonInfo.baseApiUrl}offer/make';
  try {
    var postData = jsonEncode(({
      'clinicId': clinicId,
      'applicationId': applicationId,
      'price': price
    }));

    // POST isteği yapılıyor
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },
      body: postData,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
    } else {
      // API call failed
      print('Failed to make API call. Status Code: ${response.statusCode}');
      // Example: Show error message
    }
  } catch (e) {
    print('Exception occurred: $e');
    // Example: Show error message
    showErrorMessage('Exception occurred: $e');
  }
  return null;
}

void showSuccessMessage() {
  // Show a success message to the user (e.g., using SnackBar)
  // Example:
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   content: Text('Offer successfully submitted.'),
  //   duration: Duration(seconds: 2),
  // ));
}
void showErrorMessage(String message) {
  // Show an error message to the user (e.g., using SnackBar)
  // Example:
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   content: Text('Error: $message'),
  //   duration: Duration(seconds: 2),
  // ));
}

Future<ClientDataResponse> fetchMadeOffers() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var clinicId = prefs.getInt('clinicId') as int;

  final response = await http.get(
      Uri.parse('${CommonInfo.baseApiUrl}Offer/GetMade?clinicId=$clinicId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },
      );

  if (response.statusCode == 200) {
    var x = ClientDataResponse.fromJson(jsonDecode(response.body));
    return x;
  } else {
    throw Exception('Failed to load applications');
  }
}

Future<bool> renewPassword(String username, String password) async {
  String apiUrl = '${CommonInfo.baseApiUrl}auth/RenewPassword';
  try {
    var postData = jsonEncode(({
      'newPassword': password,
      'username':username      
    }));

    // POST isteği yapılıyor
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',   
        'Authorization' : 'basic YXBweWtvOjE5MDM='     
      },
      body: postData,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      // API call failed
      showErrorMessage('Failed to make API call. Status Code: ${response.statusCode}');
      return false;
      // Example: Show error message
    }
  } catch (e) {
    print('Exception occurred: $e');
    // Example: Show error message
    showErrorMessage('Exception occurred: $e');
    return false;
    
  }
}

Future<void> logout() async {
  final storage = const FlutterSecureStorage();
  SharedPreferences prefs;

  try {
    // Initialize SharedPreferences
    prefs = await SharedPreferences.getInstance();

    // Clear data in FlutterSecureStorage
    await storage.deleteAll();

    // Clear data in SharedPreferences
    await prefs.clear();
  } catch (e) {
    // Handle any errors that occur during logout process
    print('Error during logout: $e');
    // Optionally, re-throw or handle the error as needed
    rethrow;
  }
}

Future<Clinic> fetchClinic() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var clinicId = prefs.getInt('clinicId') as int;

  String apiUrl = '${CommonInfo.baseApiUrl}clinics/getByid?id=$clinicId';

  final response = await http.get(Uri.parse(apiUrl),
  headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'basic YXBweWtvOjE5MDM='   
      },);

  if (response.statusCode == 200) {
    return Clinic.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load clinic data');
  }
}
