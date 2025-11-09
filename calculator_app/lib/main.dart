import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

const Color appBarColor = Color(0xFF607D8B);
const Color calcKeyboard = appBarColor;
const Color bodyColor = Color(0xFF455A64);

void main() {
  runApp(const MyApp());
}

Widget calcButton(String text, {Color color = Colors.black, required Function(String) onPressed}) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: () => (text != '') ? onPressed(text) : '',
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _expression = '';
  String _result = '0';

  void _onButtonPressed(String text) {
    print("button pressed: $text"); // mantém debug print

    setState(() {
      if (text == 'AC') {
        _expression = '';
        _result = '0';
      } else if (text == 'C') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (text == '=') {
        _calculateResult();
      } else {
        _expression += text;
      }
    });
  }

  void _calculateResult() {
    try {
      final expStr = _expression.replaceAll('×', '*').replaceAll('÷', '/');

      final sanitized = expStr.replaceAll(' ', '');
      if (sanitized.contains('/0') && !sanitized.contains('/0.')) {
        _result = 'Não é possível dividir por zero';
        return;
      }

      final parser = GrammarParser();
      final expr = parser.parse(expStr);
      final evaluator = RealEvaluator();
      final value = evaluator.evaluate(expr);

      // Remove casas decimais desnecessárias
      _result = (value % 1 == 0) ? value.toInt().toString() : value.toString();
    } catch (e) {
      _result = 'Error';
    }
  }

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
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape =
                MediaQuery.of(context).orientation == Orientation.landscape;

            final visorFlex = 2;
            final spaceFlex = isLandscape ? 1 : 4;
            final keyboardFlex = isLandscape ? 3 : 6;

            return Container(
              color: bodyColor,
              child: Column(
                children: [
                  // ---------- (1) Visores ----------
                  Expanded(
                    flex: visorFlex,
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.only(right: 12, bottom: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // expressão rolável
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: Text(
                              _expression.isEmpty ? defaultValue : _expression,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          // resultado rolável
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: Text(
                              _result,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                              calcButton("7", onPressed: _onButtonPressed),
                              calcButton("8", onPressed: _onButtonPressed),
                              calcButton("9", onPressed: _onButtonPressed),
                              calcButton("C", color: Colors.red.shade900, onPressed: _onButtonPressed),
                              calcButton("AC", color: Colors.red.shade900, onPressed: _onButtonPressed),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              calcButton("4", onPressed: _onButtonPressed),
                              calcButton("5", onPressed: _onButtonPressed),
                              calcButton("6", onPressed: _onButtonPressed),
                              calcButton("+", color: Colors.white, onPressed: _onButtonPressed),
                              calcButton("-", color: Colors.white, onPressed: _onButtonPressed),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              calcButton("1", onPressed: _onButtonPressed),
                              calcButton("2", onPressed: _onButtonPressed),
                              calcButton("3", onPressed: _onButtonPressed),
                              calcButton("×", color: Colors.white, onPressed: _onButtonPressed),
                              calcButton("÷", color: Colors.white, onPressed: _onButtonPressed),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              calcButton("0", onPressed: _onButtonPressed),
                              calcButton(".", onPressed: _onButtonPressed),
                              calcButton("00", onPressed: _onButtonPressed),
                              calcButton("=", color: Colors.white, onPressed: _onButtonPressed),
                              calcButton("", onPressed: _onButtonPressed),
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
