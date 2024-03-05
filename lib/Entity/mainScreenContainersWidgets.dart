import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MainScreenContainersWidgets extends StatefulWidget {
  final String imageSrc;
  MainScreenContainersWidgets({ Key? key, required this.imageSrc}) : super(key: key);

  @override
  State<MainScreenContainersWidgets> createState() => _MainScreenContainersWidgetsState();
}

class _MainScreenContainersWidgetsState extends State<MainScreenContainersWidgets> {

    @override
    Widget build(BuildContext context){
      return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image:
                  DecorationImage(image: AssetImage(widget.imageSrc), fit: BoxFit.cover)),
          width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / 7,
          height: MediaQuery.of(context).size.height / 6,
        )
      );
    }
}