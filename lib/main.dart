import 'package:covid19_dashboard/models/covid19_data.dart';
import 'package:covid19_dashboard/screens/details.dart';
import 'package:covid19_dashboard/screens/overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  //debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => Covid19DataContext(),
    child: FutureProvider(
      create: (context) => Covid19DataContext().fetchingData,
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PagesScreen(),
    );
  }
}

class PagesScreen extends StatefulWidget {
  @override
  _PagesScreenState createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          OverviewScreen(),
          DetailsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.orange,
            icon: Icon(Icons.settings_overscan),
            title: Text('Overview'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.deepOrange,
            icon: Icon(Icons.details),
            title: Text('Details'),
          ),
        ],
      ),
    );
  }
}
