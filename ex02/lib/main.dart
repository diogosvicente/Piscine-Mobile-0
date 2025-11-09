import 'package:flutter/material.dart';

const Color appBarColor = Color(0xFF607D8B);
const Color calcKeyboard = appBarColor;
const Color bodyColor = Color(0xFF455A64);

void main() {
  runApp(const MyApp());
}

Widget calcButton(String text, {Color color = Colors.black}) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.zero, // sem espaço externo
      padding: EdgeInsets.zero, // sem espaço interno
      child: ElevatedButton(
        onPressed: () => print("button pressed: $text"),
        style: ElevatedButton.styleFrom(
          backgroundColor: calcKeyboard,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
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
        appBar: AppBar(
          title: const Text(appBarTitle),
          centerTitle: true,
          backgroundColor: appBarColor,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          )
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape =
                MediaQuery.of(context).orientation == Orientation.landscape;

            final visorFlex = isLandscape ? 2 : 2;
            final spaceFlex = isLandscape ? 1 : 4;
            final keyboardFlex = isLandscape ? 3 : 6;

            return Container(
              color: const Color(0xFF455A64),
              child: Column(
                children: [
                  // ---------- (1) Visores ----------
                  Expanded(
                    flex: visorFlex,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextField(
                          controller: TextEditingController(text: defaultValue),
                          readOnly: true,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.only(
                              right: 12,
                              bottom: 4,
                            ),
                          ),
                        ),
                        TextField(
                          controller: TextEditingController(text: defaultValue),
                          readOnly: true,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.only(
                              right: 12,
                              bottom: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---------- (2) Espaço vazio ----------
                  Expanded(flex: spaceFlex, child: const SizedBox()),

                  // ---------- (3) Teclado ----------
                  Expanded(
                    flex: keyboardFlex,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              calcButton("7"),
                              calcButton("8"),
                              calcButton("9"),
                              calcButton("C", color: Colors.red.shade900),
                              calcButton("AC", color: Colors.red.shade900),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              calcButton("4"),
                              calcButton("5"),
                              calcButton("6"),
                              calcButton("+", color: Colors.white),
                              calcButton("-", color: Colors.white),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              calcButton("1"),
                              calcButton("2"),
                              calcButton("3"),
                              calcButton("×", color: Colors.white),
                              calcButton("÷", color: Colors.white),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              calcButton("0"),
                              calcButton("."),
                              calcButton("00"),
                              calcButton("=", color: Colors.white),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
