import 'package:flutter/widgets.dart';
import 'package:n_n/Entity/dataChecker.dart';


class DataItherited extends InheritedWidget {
  DataChecker _checker = DataChecker();
  int index = 0;
  DataItherited({Key? key, required child})
      : super(key: key, child: child);

  static DataItherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataItherited>();
  }

  @override
  bool updateShouldNotify(DataItherited oldWidget) {
    return _checker.index != oldWidget._checker.index || _checker.data != oldWidget._checker.data;
  }

  String getName(){
    return _checker.getName();
  }

  int getIndex(){
    return _checker.index;
  }

  void updateChecker(int index){
    _checker.index = index;
  }

}
