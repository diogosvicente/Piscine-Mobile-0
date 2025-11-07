import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String appBarTitle = "Calculator";
  static const String defaultValue = "0";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appBarTitle),
          centerTitle: true,          
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: TextEditingController(text: defaultValue),
                readOnly: true,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 32),
              ),
              SizedBox(height: 10),
              TextField(
                controller: TextEditingController(text: defaultValue),
                readOnly: true,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ],
          )
        )
      )
    );
  }
}
