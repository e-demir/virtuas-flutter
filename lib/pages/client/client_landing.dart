import 'package:flutter/material.dart';
import 'package:vituras_health/models/category.dart';
import 'package:vituras_health/pages/client/client_selected_category.dart';
import 'package:vituras_health/pages/client/applications.dart';
import 'package:vituras_health/pages/client/profile.dart';
import 'package:vituras_health/services/dataService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientLandingPage extends StatefulWidget {
  const ClientLandingPage({super.key});

  @override
  _ClientLandingPageState createState() => _ClientLandingPageState();
}

class _ClientLandingPageState extends State<ClientLandingPage> {
  int? userId;
  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ?? 0;
    });
  }

  int _selectedIndex = 1; // Discover page is the default

  List<Category> categories = [];
  final DataService _dataService = DataService();
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
    fetchDataOnLoad();
    _loadUserId();
  }

  void fetchDataOnLoad() async {
    List<Category> fetchedData = await _dataService.fetchCategories();
    setState(() {
      categories = fetchedData;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildProfilePage() {
    if (userId == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
      decoration: _boxDecoration,
      child: ProfilePage(userId: userId!),
    );
  }

  Widget _buildDiscoverPage() {
  
  return Container(
    decoration: _boxDecoration,
    child: Padding(
      padding: const EdgeInsets.all(20.0), // Padding around the content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 150),
          Text(
            'Vituras',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                  
                  // fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50), // Minimal space between top and first sentence
          Text(
            'Get Your Best Medical Offers',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600
                  
                ),            
          ),
          const SizedBox(height: 20), // Space between subtitle and dropdown
           Text(
            'Discover all the health services and get exclusive offers from most qualified clinics and doctors',
            style: Theme.of(context).textTheme.headlineSmall ?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w300
                ),
            
          ),
          const SizedBox(height: 50), // 
          
         DropdownButtonFormField<Category>(
  decoration: InputDecoration(
    hintText: 'Choose one to start',
    hintStyle: TextStyle(
      color: Colors.white, // Set the hint text color to white
    ),
    filled: false,
    fillColor: Colors.transparent, // Ensure background color is transparent
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(2.0), // Rounded corners
      borderSide: BorderSide(
        color: Colors.white, // Border color to match the hint text
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(2.0), // Rounded corners
      borderSide: BorderSide(
        color: Colors.white, // Border color to match the hint text
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(2.0), // Rounded corners
      borderSide: BorderSide(
        color: Colors.white, // Border color to match the hint text
      ),
    ),
  ),
  value: null,
  onChanged: (Category? newValue) {
    if (newValue != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CategoryDetailPage(category: newValue),
        ),
      );
    }
  },
  items: categories.map((Category category) {
    return DropdownMenuItem<Category>(
      value: category,
      child: Text(
        category.title,
        style: TextStyle(color: Color(0xff0052d4)), // Make item text white
      ),
    );
  }).toList(),
)

        ],
      ),
    ),
  );
}



  Widget _buildApplicationsPage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff42cff0), Color(0xff42cff0), Color(0xff1276ef)],
          stops: [0, 0.3, 1],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: const ApplicationsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      _buildProfilePage(),
      _buildDiscoverPage(),
      _buildApplicationsPage(),
    ];

    return Scaffold(
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 84, 190, 87),        
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_drive_file),
              label: 'Applications',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white, // Color for the selected item
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          
          unselectedItemColor: Colors.white,
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent, // Make background transparent
        ),
      ),
    );
  }
}
