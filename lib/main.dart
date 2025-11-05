import 'package:flutter/material.dart';

void main(){
  runApp(const Dinereserve());
}

class Dinereserve extends StatelessWidget{
  const Dinereserve({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
    );
  }

}