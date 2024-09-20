import 'package:flutter/material.dart';
import 'package:virtual_twin/authenticationPage.dart';
class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: Text(
              '"Energy is the most vital resource, \njust save it"',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 154, 227, 213),
                fontSize: 50,
                fontStyle: FontStyle.italic,
                //fontWeight: FontWeight.bold, // Make the text bold
                fontFamily: 'Cleopathra',
              ),
            ),
          ),
          SizedBox(height: 40), // Add some space between the text and the button
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AuthenticationPage()),
              ); // Navigate to the authentication page
            },
            child: Text('Start'),
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(115, 59, 21, 163), // Button color
              onPrimary: Color.fromARGB(255, 154, 227, 213), // Text color
              side: BorderSide(color: Color.fromARGB(255, 154, 227, 213), width: 2), // Border color and width
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
    );
  }
}
