import 'package:flutter/material.dart';

void main() {
  runApp(MyWidget(title: 'Título Legal'));
}

class MyWidget extends StatelessWidget {

  final String title;

  const MyWidget({super.key, required this.title});


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: Text(
          title,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 50.0
          )
        )
      ),
    );
  }
}