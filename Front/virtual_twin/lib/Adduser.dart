
import 'package:flutter/material.dart';
import 'package:virtual_twin/auth_service.dart';
// Ensure this path is correct
// Import the admin page

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'Simple User';

  void _addUser() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String role = _selectedRole;

    print("Adding user: $username, Email: $email, Password: $password, Role: $role");
    // Implement your add user functionality here
    // Example:
    AuthService authService = AuthService();
    bool success = await authService.addUser(username, email, password, role);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User Added Successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Add User')),
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
                      'Add User',
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
                        _emailController.clear();
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
                        SizedBox(height: 20),
                        Container(
                          width: 500,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                  color: Color.fromARGB(218, 171, 231, 219),
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _emailController,
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
                        SizedBox(height: 20),
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
                        SizedBox(height: 20),
                        Container(
                          width: 500,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Role',
                                style: TextStyle(
                                  color: Color.fromARGB(218, 171, 231, 219),
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _selectedRole,
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
                                items: ['Simple User', 'Admin'].map((String role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedRole = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: _addUser,
                          child: Text('Add User'),
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
