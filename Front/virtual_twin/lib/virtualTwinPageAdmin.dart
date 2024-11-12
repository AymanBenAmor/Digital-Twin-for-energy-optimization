import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:virtual_twin/Adduser.dart';
import 'package:virtual_twin/auth_service.dart';
import 'package:virtual_twin/popup_margeTemp.dart';
import 'package:url_launcher/url_launcher.dart';


class VirtualTwinPageAdmin extends StatefulWidget {
  @override
  _VirtualTwinPageState createState() => _VirtualTwinPageState();
}

class _VirtualTwinPageState extends State<VirtualTwinPageAdmin> {
  bool _isFirstLoad = true;
  String _currentTime = '';
  int _minTemp = 0;
  int _maxTemp = 0;
  int _countdownMinutes = 10;
  int _countdownSeconds = 0;
  Timer? _countdownTimer;
  double time = 0;
  String clim_state = 'Opened';

  dynamic outside_temp = 0.0;
  dynamic outside_hum = 0.0;
  dynamic outside_solar_rad = 0.0;
  List<FlSpot> _timeDataSpots = [];




  @override
   void initState() {
    super.initState();
    _getWeatherData();
    
    
    _updateTime();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isFirstLoad) {
        _showPopup();
        setState(() {
          _isFirstLoad = false;
        });
      }
    });
  }

  void _FetchTimeCalculated() async {
    try {
      final timedata = await AuthService().fetchTimeData();
      setState(() {
        _timeDataSpots = timedata.map((data) => FlSpot(data.time.toDouble(), data.value.toDouble())).toList();
      });
    } catch (e) {
      print('Error fetching time data: $e');
    }
  }


  void _getWeatherData() async {
    try {
      final weatherData = await AuthService.fetchWeather();
      
     
      setState(() {
        outside_temp = weatherData['temp'];
        outside_hum = weatherData['hum'];
        outside_solar_rad = weatherData['solar_rad'];
        
      });
      print("temp : $outside_temp \n hum : $outside_hum \n solar_rad : $outside_solar_rad");
    } catch (e) {
      print('Failed to fetch weather data: $e');
    }
  }
  

  void _updateTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = TimeOfDay.now().format(context); // Get current time
        });
      }
    });
  }

  void _showCurveDialog() {
    _FetchTimeCalculated(); // Ensure the time data is fetched before showing the curve
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Time Data Curve',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 300,
                  width: double.infinity,
                  child: _buildLineChart(),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: _timeDataSpots,
            isCurved: true,
            barWidth: 4,
            
          ),
        ],
      ),
    );
  }

  void _startCountdown() {
    _countdownTimer?.cancel();

    setState(() {
      _countdownMinutes = time.toInt();
      _countdownSeconds = ((time - _countdownMinutes) * 60).toInt();
      clim_state = "Closed";
    });

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownMinutes == 0 && _countdownSeconds == 0) {
        timer.cancel();
        _showOpenPopup();
      } else {
        setState(() {
          if (_countdownSeconds == 0) {
            _countdownMinutes--;
            _countdownSeconds = 59;
          } else {
            _countdownSeconds--;
          }
        });
      }
    });
  }

  void _startCountUp() {
    _countdownTimer?.cancel();

    setState(() {
      _countdownMinutes = time.toInt();
      _countdownSeconds = ((time - _countdownMinutes) * 60).toInt();
      clim_state = "Opened";
    });

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownMinutes == 0 && _countdownSeconds == 0) {
        timer.cancel();
        _showClosePopup();
      } else {
        setState(() {
          if (_countdownSeconds == 0) {
            _countdownMinutes--;
            _countdownSeconds = 59;
          } else {
            _countdownSeconds--;
          }
        });
      }
    });
  }

  void _showPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: PopupMargeTemp(
            onTemperatureSelected: (minTemp, maxTemp, _time) {
              setState(() {
                _minTemp = minTemp;
                _maxTemp = maxTemp;
                time = _time;
              });
              
              _startCountdown();
            },
          ),
        );
      },
    );
  }

  void _showClosePopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.red, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'CLOSE',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    int supp = _maxTemp;
                    _maxTemp = _minTemp;
                    _minTemp = supp;
                   
                    _startCountdown();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                  style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Replaces `primary`
                textStyle: TextStyle(fontSize: 20),
              ),

                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOpenPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.green, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'OPEN',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    int supp = _maxTemp;
                    _maxTemp = _minTemp;
                    _minTemp = supp;
                    
                    _startCountUp();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _refreshPopup() {
    _countdownTimer?.cancel();

    setState(() {
      _minTemp = 0;
      _maxTemp = 0;
      _countdownMinutes = 10;
      _countdownSeconds = 0;
    });

    _showPopup();
  }

  void _navigateToAddUser() {
    print("navigated to adduserpage");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddUserPage()),
    );
  }

  void _goDataBase() async {
  const url = 'http://127.0.0.1:8000/admin/auth/'; // Replace with your desired URL
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  final countdownText = '${_countdownMinutes.toString().padLeft(2, '0')}:${_countdownSeconds.toString().padLeft(2, '0')}';
  Color climStateColor = clim_state == 'Opened' ? Colors.green : Colors.red;

  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Virtual Twin',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.white),
          onPressed: _refreshPopup,
        ),
        IconButton(
          icon: Icon(Icons.person_add, color: Colors.white),
          onPressed: _navigateToAddUser,
        ),
        Tooltip(
        message: 'Manage database',
        child: IconButton(
          icon: Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            
            _goDataBase();
            // Add your desired action here
          },
        ),
      ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _currentTime,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ),
    extendBodyBehindAppBar: true,
    body: Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      color: Colors.black.withOpacity(0.5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$_minTemp°C',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 50),
                          Column(
                            children: [
                              Container(
                                width: 80,
                                height: 2,
                                color: Colors.white,
                              ),
                              SizedBox(height: 2),
                              Text(
                                countdownText,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: 80,
                                height: 2,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(width: 50),
                          Text(
                            '$_maxTemp°C',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 620,
                      height: 520,
                      child: Image.asset(
                        'assets/images/departement.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 65,
                right: 80,
                child: Text(
                  clim_state,
                  style: TextStyle(
                    fontSize: 25,
                    color: climStateColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                top: 135,
                left: 30, // Adjust this value to position the box
                child: Container(
                  width: 260,
                  height: 520,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color.fromARGB(162, 255, 255, 255), width: 1.5),  
                  ),
                  child: Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                      SizedBox(height: 10),
                      Text(
                        'Outside Weather',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 50),
                      Image.asset(
                        'assets/images/temperature_icon.png', // Your temperature icon
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(height: 5),

                      Text("Temperature : $outside_temp°C",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                      ),

                      SizedBox(height: 30),
                      Image.asset(
                        'assets/images/hum_logo.png', // Your temperature icon
                        width: 60,
                        height: 60,
                      ),

                      SizedBox(height: 5),

                      Text("Humidity : $outside_hum%",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                      ),
                      SizedBox(height: 30),
                      Image.asset(
                        'assets/images/solar_rad.png', // Your temperature icon
                        width: 70,
                        height: 70,
                      ),
                      SizedBox(height: 5),

                      Text("Solar radiation : $outside_solar_rad W/m²",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 135,
                right: 30, // Adjust this value to position the box
                child: Container(
                  width: 260,
                  height: 520,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color.fromARGB(162, 255, 255, 255), width: 1.5),  
                  ),
                  child: Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                      SizedBox(height: 10),
                      Text(
                        'Profits',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 50),
                      GestureDetector(
                          onTap: () {
                            _showCurveDialog(); // Show the curve when temp.png is clicked
                          },
                          child: Image.asset(
                            'assets/images/time.png', // Your temperature icon
                            width: 60,
                            height: 60,
                          ),
                        ),
                      SizedBox(height: 5),

                      Text("Time Profit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                      ),

                      SizedBox(height: 30),
                      Image.asset(
                        'assets/images/energy_icon.png', // Your temperature icon
                        width: 60,
                        height: 60,
                      ),

                      SizedBox(height: 5),

                      Text("Energy Profit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      ),
                      ),
                      SizedBox(height: 30),
                      Image.asset(
                        'assets/images/money_icon.png', // Your temperature icon
                        width: 70,
                        height: 70,
                      ),
                      SizedBox(height: 5),

                      Text("Money Profit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}