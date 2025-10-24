import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: Ex00()));
}

class Ex00 extends StatefulWidget {
  const Ex00({super.key});

  @override
  State<Ex00> createState() => _Ex00State();
}

class _Ex00State extends State<Ex00> {
  bool reversed = false;

  @override
  Widget build(BuildContext context) {
    // Cria a lista de campos
    final fields = [
      const MyTextBox(label: 'Caixa 1'),
      const MyTextBox(label: 'Caixa 2'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Sem Key')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: reversed ? fields.reversed.toList() : fields,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            reversed = !reversed; // inverte a ordem
          });
        },
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }
}

class MyTextBox extends StatefulWidget {
  final String label;
  const MyTextBox({required this.label});

  @override
  State<MyTextBox> createState() => _MyTextBoxState();
}

class _MyTextBoxState extends State<MyTextBox> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      width: 150,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
