import 'package:flutter/material.dart';
import 'package:vituras_health/models/add_category.dart';
import 'package:vituras_health/models/question.dart';
import 'package:vituras_health/pages/admin/common_widget.dart';
import 'package:vituras_health/services/categoryService.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final CategoryService _categoryService = CategoryService();
  List<AddCategory> _categories = [];
  List<AddCategory> _filteredCategories = [];
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    try {
      List<AddCategory> categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories;
        _filteredCategories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  void _filterCategories(String query) {
    List<AddCategory> filteredList = _categories.where((category) {
      return category.title.toLowerCase().contains(query.toLowerCase()) ||
          category.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredCategories = filteredList;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _filteredCategories = _categories;
        _searchController.clear();
      }
    });
  }

  void _navigateToUpdateCategoryPage(AddCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCategoryPage(category: category),
      ),
    ).then((_) {
      // Eğer güncelleme yapılmışsa, sayfayı yeniden yükleyelim
      _loadCategories();
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
                  onChanged: _filterCategories,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    focusColor: Color.fromARGB(0, 242, 242, 242),
                    hintText: 'Search...',
                    hintStyle: TextStyle(fontSize: 15, color: Colors.white),
                    border: InputBorder.none,
                  ),
                )
              : const Text(
                  'Categories',
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
                itemCount: _filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = _filteredCategories[index];
                  return GestureDetector(
                    onTap: () => _navigateToUpdateCategoryPage(
                        category), // Tıklama ile düzenleme sayfasına yönlendirme
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 1,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                category.description,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Credit: ${category.credit}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
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
