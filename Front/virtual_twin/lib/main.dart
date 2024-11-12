

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:virtual_twin/homePage.dart';


void main() async {
  runApp(MyApp());
  runBatchFile() ;
 
}

void runBatchFile() async {
    try {
      // Path to your batch file
      String pathToBatchFile = 'D:\\cours_II2\\S2\\stage\\Application\\run_server.bat';

      // Run the batch file
      ProcessResult result = await Process.run(pathToBatchFile, []);

      // Print the output of the batch file
      print('Exit code: ${result.exitCode}');
      print('Standard Output: ${result.stdout}');
      print('Error Output: ${result.stderr}');

      // Optionally, show a message dialog
      if (result.exitCode == 0) {
        print('Batch file executed successfully.');
      } else {
        print('Error executing batch file.');
      }
    } catch (e) {
      print('Error: $e');
    }
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
