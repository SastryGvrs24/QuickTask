import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUp() async {
    var user = ParseUser(_usernameController.text, _passwordController.text, null);
    var response = await user.signUp(allowWithoutEmail: true);

    if (response.success) {
      Navigator.pushReplacementNamed(context, '/login');  // Navigate to the Login screen after successful sign-up
    } else {
      print('Sign up failed: ${response.error?.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QuickTask - Sign Up')),
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
              onPressed: _signUp,
              child: Text('SignUp'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');  // Navigate to the Login screen
              },
              child: Text('Already have an account? Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
