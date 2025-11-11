import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  String texto = "A simple text";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(      
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 88, 96, 30),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  texto,
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  print("Button pressed");
                  setState(() {
                    texto = (texto == "A simple text") ? "Hello World" : "A simple text";
                  });
                  }, child: const Text(
                    'Click me',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 91, 99, 31),
                  )
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
