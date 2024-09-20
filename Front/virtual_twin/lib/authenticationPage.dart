import 'package:flutter/material.dart';
import 'package:virtual_twin/virtualTwinPageAdmin.dart';
import 'auth_service.dart'; // Make sure the path is correct
import 'virtualTwinPage.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    Map<String, dynamic> response = await _authService.authenticate(username, password);

    if (response['status'] == 'success') {
        bool isAdmin = response['is_staff'] ?? false; // Adjust based on your API response

        if (isAdmin) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VirtualTwinPageAdmin()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VirtualTwinPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication Failed')),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 40),
                    Text(
                      'Authentication',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        _usernameController.clear();
                        _passwordController.clear();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 500,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Username',
                                style: TextStyle(
                                  color: Color.fromARGB(218, 171, 231, 219),
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(209, 1, 6, 41),
                                      width: 1,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color.fromARGB(219, 136, 230, 253),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          width: 500,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password',
                                style: TextStyle(
                                  color: Color.fromARGB(218, 171, 231, 219),
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(209, 1, 6, 41),
                                      width: 1,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color.fromARGB(206, 136, 230, 253),
                                ),
                                obscureText: true,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: _login,
                          child: Text('Login'),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(115, 59, 21, 163),
                            onPrimary: Color.fromARGB(255, 154, 227, 213),
                            side: BorderSide(color: Color.fromARGB(255, 154, 227, 213), width: 2),
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                            textStyle: TextStyle(
                              fontSize: 30,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
