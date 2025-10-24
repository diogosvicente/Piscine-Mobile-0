import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color.fromARGB(255, 88, 96, 30), borderRadius: BorderRadius.circular(15)),
              child: Text(
                'A simple text',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color.fromARGB(255, 239, 235, 223), borderRadius: BorderRadius.circular(25)),
              child: Text(
              'Click me',
              style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 91, 99, 31)),
            ),
            )
          ],
          ),
        )
      ),
    );
  }
}