import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CardClass extends StatefulWidget {
  const CardClass({ Key? key }) : super(key: key);

  @override
  _CardClassState createState() => _CardClassState();
}

class _CardClassState extends State<CardClass> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
        Container(
          width: MediaQuery.of(context).size.width - 140, 
          height: MediaQuery.of(context).size.height / 4 , 
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 182, 71, 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 4,
                offset: Offset(0, 0), // Shadow position
              ),
            ],
            borderRadius: BorderRadius.circular(20),
            )
          ),
      ],),
    );
  }
}

// Stack(
//           children: [
//             Container(
//             height: MediaQuery.of(context).size.height / 4,
//             width: MediaQuery.of(context).size.width - 140,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: Color.fromRGBO(255, 182, 71, 1),
//               ),
            
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   textDirection: TextDirection.ltr,
//                   children: [
//                     Text(widget.checker.data.isEmpty ? "Выберете сверху нужынй вам раздел" : widget.checker.data[widget.checker.word_index].word, style: const TextStyle(color: Colors.white),),
//                     Text(_lastWords, style: TextStyle(color: Colors.black),),
//                   ],
//                 ),
//               ),
//             ),
//           ), 
//           Container(width: 40, height: 40, color: Colors.black)
//           ],
//         )