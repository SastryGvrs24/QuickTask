import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    var user = ParseUser(_usernameController.text, _passwordController.text, null);
    var response = await user.login();

    if (response.success) {
      Navigator.pushReplacementNamed(context, '/tasks');
    } else {
      print('Login failed: ${response.error?.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QuickTask - Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signup'); // Navigate to the SignUp screen
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
