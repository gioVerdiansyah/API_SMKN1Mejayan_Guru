import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NextPrevDayComponent extends StatelessWidget{
  final void Function(String) prevDay;
  final int theDay;

  NextPrevDayComponent({required this.prevDay, required this.theDay});

  void _incrementDay(){
      prevDay('plus');
  }
  void _decrementDay(){
      prevDay('minus');
  }
  @override
  Widget build(BuildContext context){
    // Handle element pagination
    late List<Widget> paginate;
    late MainAxisAlignment handleMainAxis;

    if (theDay != 0 && theDay >= 0) {
      handleMainAxis = MainAxisAlignment.spaceBetween;
      paginate = [
        TextButton(
            onPressed: () {
              _decrementDay();
            },
            child: const Text("<< Prev day")),
        TextButton(
            onPressed: () {
              _incrementDay();
            },
            child: const Text("Next day >>"))
      ];
    } else if (theDay != 0) {
      handleMainAxis = MainAxisAlignment.start;
      paginate = [
        TextButton(
            onPressed: () {
              _decrementDay();
            },
            child: const Text("<< Prev day"))
      ];
    } else if (theDay >= 0) {
      handleMainAxis = MainAxisAlignment.end;
      paginate = [
        TextButton(
            onPressed: () {
              _incrementDay();
            },
            child: const Text("Next day >>"))
      ];
    } else {
      print('kososng');
      handleMainAxis = MainAxisAlignment.start;
      paginate = [TextButton(onPressed: () {}, child: const Text("kosong"))];
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: handleMainAxis, children: paginate),
    );
  }
}