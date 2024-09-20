

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:virtual_twin/homePage.dart';


void main() async {
  runApp(MyApp());
startDjangoServer();  
}


Future<void> startDjangoServer() async {
  // Adjust the path to your batch file
  final batchFilePath = 'C:\\path\\to\\your\\start_django_server.bat';

  // Start the server in a background process
  Process.start('cmd.exe', ['/c', batchFilePath]).then((Process process) {
    process.stdout.transform(SystemEncoding().decoder).listen((data) {
      print(data);
    });

    process.stderr.transform(SystemEncoding().decoder).listen((data) {
      print('Error: $data');
    });

    process.exitCode.then((exitCode) {
      print('Process exited with code $exitCode');
    });
  });
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Background Demo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: home(),  // Use the home widget
      ),
    );
  }
}
