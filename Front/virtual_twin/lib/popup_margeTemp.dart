import 'package:flutter/material.dart';
import 'package:virtual_twin/auth_service.dart';

class PopupMargeTemp extends StatefulWidget {
  final Function(int, int, double) onTemperatureSelected; // Callback function

  PopupMargeTemp({required this.onTemperatureSelected});

  @override
  _PopupMargeTempState createState() => _PopupMargeTempState();
}

class _PopupMargeTempState extends State<PopupMargeTemp> {
  final TextEditingController _minTempController = TextEditingController();
  final TextEditingController _maxTempController = TextEditingController();
  final AuthService _authService = AuthService();

  double _time = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchTime(int minTemp, int maxTemp) async {
    try {
      final time = await _authService.fetchTime(minTemp, maxTemp);
      setState(() {
        _time = time;
      });
      print("time calculated $_time");
    } catch (e) {
      print("error: $e");
    }
  }

  bool _validateTemperatures(int minTemp, int maxTemp) {
    if (minTemp < 18 || minTemp > 30) {
      setState(() {
        _errorMessage = "Min temp must be between 18 and 30.";
      });
      return false;
    }
    if (maxTemp < 18 || maxTemp > 30) {
      setState(() {
        _errorMessage = "Max temp must be between 18 and 30.";
      });
      return false;
    }
    if (minTemp >= maxTemp) {
      setState(() {
        _errorMessage = "Min temp must be less than Max temp.";
      });
      return false;
    }
    setState(() {
      _errorMessage = null; // Clear the error message if everything is valid
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(15),
      backgroundColor: Color.fromARGB(198, 6, 137, 207),
      content: Container(
        width: 350,
        height: 350,
        decoration: BoxDecoration(
          color: Color.fromARGB(133, 141, 138, 138),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Description:\n',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'Here, we will aim to reduce energy consumption in the reception area of the research center. The idea is to choose a margin of comfort temperature during which the air conditioning will be turned off.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _minTempController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Min temp',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _maxTempController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Max temp',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            if (_errorMessage != null) // Display error message if validation fails
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Color.fromARGB(255, 100, 8, 1), fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color.fromARGB(255, 195, 19, 7),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final minTemp = int.parse(_minTempController.text);
                final maxTemp = int.parse(_maxTempController.text);

                if (_validateTemperatures(minTemp, maxTemp)) {
                  await fetchTime(minTemp, maxTemp);
                  if(_time == 99.99){
                      setState(() {
                        _errorMessage = "It is impossible to reach this max temperature.\nYou must decrease it";
                      });
                  }else{
                    widget.onTemperatureSelected(minTemp, maxTemp, _time);
                    Navigator.of(context).pop();
                  } // Await the fetchTime call
                  
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Color.fromARGB(255, 15, 1, 75),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
