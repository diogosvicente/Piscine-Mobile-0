import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Ex00()));

class Ex00 extends StatefulWidget {
  const Ex00();

  @override
  State<Ex00> createState() => _Ex00State();
}

class _Ex00State extends State<Ex00> {
  bool troca = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: troca
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CampoTexto(), // campo de baixo foi pra cima
                  CampoTexto(),
                ],
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CampoTexto(), // campo de cima foi pra baixo
                  CampoTexto(),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => troca = !troca),
        child: const Icon(Icons.swap_vert),
      ),
    );
  }
}

class CampoTexto extends StatefulWidget {
  const CampoTexto();

  @override
  State<CampoTexto> createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
    );
  }
}
