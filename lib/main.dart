// ignore_for_file: prefer_const_constructors
//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user.dart';
import 'schedule_page.dart';
//importing pages

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( NavigationBarApp());
}

class NavigationBarApp extends StatefulWidget {
  const NavigationBarApp({super.key});
  @override
  State<NavigationBarApp> createState() => _MainPage();
  //_MainPage createState() => _MainPage();
}
class _MainPage extends State<NavigationBarApp> {
  //default split, gets overwridden by user choices

  //getting and storing persistent data
  // late SharedPreferences _sharedPrefs;
  // getSharedPreferences() async {
  //   //print("gotsharedprefs");
  //   _sharedPrefs = await SharedPreferences.getInstance();
  //   readPrefs();
  // }

  //writePrefs(){
    
  //   List<String> splitDataList = split.map((data) => jsonEncode(data.toJson())).toList();
  //   _sharedPrefs.setStringList('splitData', splitDataList);
  // }

  // readPrefs(){
  //   //print("readprefs");
  //   List<String>? splitDataList = _sharedPrefs.getStringList('splitData');
  //   if (splitDataList != null){
  //     split = splitDataList.map((data) => SplitDayData.fromJson(json.decode(data))).toList(growable: true);
  //     //rint("split");
  //   }

  //   setState((){

  //   });
  // }

  @override

  void initState() {
    //print("initprefs");
    //getSharedPreferences();
    super.initState();
    
  }



  @override
  Widget build(BuildContext context) {
    //provider for global variable information
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (context) => Profile(
            //profile stuffs here
            ),
          ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Profile.palette[2],
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Profile.palette[2],
            brightness: Brightness.light,
          )
        ),
        //theme: ThemeData(useMaterial3: false),s
        home: NavigationExample(),
      ),
    );
  }
}

class NavigationExample extends StatefulWidget {
  NavigationExample({super.key,});
  
  @override
  _NavigationExampleState createState() => _NavigationExampleState();
}



class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
          backgroundColor: Profile.palette[0],
          title: Text("Courselink 2"),
        ),
      
      bottomNavigationBar: NavigationBar(
        backgroundColor: Profile.palette[0],
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Profile.palette[2],
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
          Radius.circular(12),
          ),
        ),

        selectedIndex: currentPageIndex,
        //different pages that can be navigated to
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.fitness_center),
            icon: Icon(Icons.fitness_center_outlined),
            label: 'Schedule',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Badge(child: Icon(Icons.calendar_month_outlined)),
            label: 'Planning',
          ),
        ],
      ),

      //what opens for each page
      body: <Widget>[
        SchedulePage(),//Center(child: Text("Schedule Page",style: TextStyle(fontSize: 32))),
        Center(child: Text("Planning Page",style: TextStyle(fontSize: 32))),

        //page widgets go here
      ][currentPageIndex],
    );
  }
}

