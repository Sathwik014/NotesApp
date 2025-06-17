import 'package:flutter/material.dart';

class Calender extends StatelessWidget {
  const Calender({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(title: Text('Calender',
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
          body:Text("Date and time"),
      ),
    );
  }
}
