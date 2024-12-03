import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quicktask/screens/login.dart';
import 'package:quicktask/screens/tasks_screen.dart';
import 'package:quicktask/screens/signup.dart';  // Don't forget to add your SignUpScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Parse Server
  await Parse().initialize(
    '',       // Replace with your Back4App App ID
    'https://parseapi.back4app.com', // Your Parse Server URL
    clientKey: '',    // Replace with your Back4App Client Key
    autoSendSessionId: true,
    debug: true,  // Set to false in production
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickTask',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(), // Implement SignUpScreen
        '/tasks': (context) => TasksScreen(),
      },
    );
  }
}
