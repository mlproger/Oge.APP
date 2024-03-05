import 'package:flutter/material.dart';
import 'package:n_n/Entity/termin.dart';
import 'package:n_n/main.dart';

class DataChecker{
  int index = 0;
  int word_index = 0;
  List<Termin> data = politicsData;
  String getName(){
    switch(index){
      case 0: return "Политическая сфера";
      case 1: return "Экономическая сфера"; 
      case 2: return "Социальная сфера";
      case 3: return "Духовная сфера";
      default : return "ERROR";
    }
  }

  List<Termin> update(){
    switch(index){
      case 0: {
        data = politicsData;
        word_index = 0;
        return politicsData;
      }
      case 1: {
        data = economyData;
        word_index = 0;
        return economyData;
      }
      case 2: {
        data = sociumData;
        word_index = 0;
        return sociumData;
      }
      case 3: {
        data = soulsData;
        word_index = 0;
        return soulsData;
      }
      default : return [];
    }
  }



}