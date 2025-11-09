import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

Widget calcButton(String text, {Color color = Colors.black}) {
  return Expanded(
    child: ElevatedButton(
        onPressed: () {
          print("button pressed :$text");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF607D8B),
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 2,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String appBarTitle = "Calculator";
  static const String defaultValue = "0";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text(appBarTitle), centerTitle: true),
        body: Container(
          color: const Color(0xFF455A64),
          padding: const EdgeInsets.all(1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ---------- Parte de cima (visores) ----------
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: TextEditingController(text: defaultValue),
                    readOnly: true,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '',
                    ),
                  ),
                  const Divider(color: Colors.white54),
                  TextField(
                    controller: TextEditingController(text: defaultValue),
                    readOnly: true,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '',
                    ),
                  ),
                  const Divider(color: Colors.white54),
                ],
              ),

              // ---------- Parte de baixo (teclado) ----------
              Column(
                children: [
                  Row(
                    children: [
                      calcButton("7"),
                      calcButton("8"),
                      calcButton("9"),
                      calcButton("C", color:  Colors.red.shade900),
                      calcButton("AC", color: Colors.red.shade900),
                    ],
                  ),
                  Row(
                    children: [
                      calcButton("4"),
                      calcButton("5"),
                      calcButton("6"),
                      calcButton("+", color: Colors.white),
                      calcButton("-", color: Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      calcButton("1"),
                      calcButton("2"),
                      calcButton("3"),
                      calcButton("×", color: Colors.white),
                      calcButton("÷", color: Colors.white),
                    ],
                  ),
                  Row(
                    children: [
                      calcButton("0"),
                      calcButton("."),
                      calcButton("00"),
                      calcButton("=", color: Colors.white),
                      const Expanded(child: SizedBox()), // espaço invisível
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
