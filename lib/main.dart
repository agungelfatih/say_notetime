import 'package:flutter/material.dart';
import 'package:say_notetime/page/timer_page.dart';
import 'package:say_notetime/theme/theme.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:say_notetime/page/notes_page.dart';
import 'package:say_notetime/page/stopwatch_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
        cursorColor: darkestGrey,
        ),
        fontFamily: 'Akrobat',
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _currentIndex  = 0;
  final tabs = [
    StopwatchPage(),
    NotesPage(),
    TimerPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: FloatingNavbar(
        borderRadius: 16,
        itemBorderRadius: 10,
        iconSize: 35,
        selectedItemColor: white,
        selectedBackgroundColor: darkGrey,
        unselectedItemColor: grey ,
        currentIndex: _currentIndex,
        backgroundColor: darkestGrey,
        items: [
          FloatingNavbarItem(
              icon: Icons.timer_rounded,
              title: 'Stopwatch'
          ),
          FloatingNavbarItem(
              icon: Icons.notes_rounded,
              title: 'Notes'
          ),
          FloatingNavbarItem(
              icon: Icons.access_time_rounded,
              title: 'Timer'
          ),

        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

