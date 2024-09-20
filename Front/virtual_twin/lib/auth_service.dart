import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'http://127.0.0.1:8000/auth/';

 

 Future<Map<String, dynamic>> authenticate(String username, String password) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['is_staff']);
      return data;
    }
    throw Exception('Failed to authenticate');
  }

  Future<bool> addUser(String username, String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}add_user/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password, 'role': role}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == 'success';
    }
    return false;
  }

  Future<double> fetchTime(int minTemp, int maxTemp) async {
    final url = Uri.parse('${_baseUrl}calculate_time/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'min_temp': minTemp, 'max_temp': maxTemp}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['time'];
    } else {
      throw Exception('Failed to fetch time');
    }
  }

  static Future<Map<String,dynamic>> fetchWeather() async{
    final url = Uri.parse('${_baseUrl}fetch_weather/');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
     
      return data;
    } else {
      throw Exception('Failed to fetch weather');
    }
    
  }

Future<List<dynamic>> fetchTimeData() async {
  final url = Uri.parse('${_baseUrl}get_times_with_submission_time/');
  final response = await http.post(url);
  print("fetch and print data");

  if (response.statusCode == 200) {
    // Parse the JSON response
    List<dynamic> data = jsonDecode(response.body)['records'];

    // Print only the time_in_minutes and submission_time values
    return data;
  } else {
    throw Exception('Failed to load data');
  }
}


}


