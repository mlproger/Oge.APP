import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:n_n/UserInterface/mainScreenWidget.dart';

import 'Entity/crud.dart';
import 'Entity/dataInherited.dart';
import 'Entity/termin.dart';
import 'package:n_n/Entity/mainScreenContainersWidgets.dart';

List<Termin> politicsData = [];
List<Termin> economyData = [];
List<Termin> soulsData = [];
List<Termin> sociumData = [];

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

void _setUp()async{
  politicsData = await CrudMethods().getData("politicData");
  economyData = await CrudMethods().getData("economyData");
  sociumData = await CrudMethods().getData("sociumData");
  soulsData = await CrudMethods().getData("soulData");
  print(politicsData.length);
}

@override
  void initState() {
    _setUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OGE.APP',
      home: AnimatedSplashScreen(
        backgroundColor: Color.fromRGBO(23, 28, 38, 1),
        nextScreen: DataItherited(child: MainScreenWidget()),
        splashIconSize: 1500,
        duration: 1000,
        splash: const Image(
          image: AssetImage("lib/Resources/assets/images/oge.png"),
          width: 2000,
          height: 2000,
        ),
      ),
    );
  }
}

