import 'package:flutter/material.dart';
import '../Entity/dataInherited.dart';
import 'mainScreenWidget.dart';

class AppBarTitle extends StatelessWidget {
AppBarTitle({ Key? key, required this.name}) : super(key: key);
  String name;
  @override
  Widget build(BuildContext context){
    return Row(mainAxisAlignment: MainAxisAlignment.center,children: [const Icon(Icons.keyboard_arrow_down), Text(name)],);}
}