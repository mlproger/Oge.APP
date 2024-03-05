import 'dart:convert';
import 'dart:math';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:edit_distance/edit_distance.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../Entity/dataChecker.dart';
import '../Entity/dataInherited.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../Entity/mainScreenContainersWidgets.dart';
import 'package:http/http.dart' as http;

import 'appBarTitle.dart';


class MainScreenWidget extends StatefulWidget {
  DataChecker checker = DataChecker();
  MainScreenWidget({ Key? key }) : super(key: key);
  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  Map<int, bool> a = {};
  String correct_ans = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      finalTimeout: Duration(seconds: 5),
      onStatus: (status) {
        if(status == "done"){
          _speechToText.stop();
          setState(() {
            _lastWords = '';
          });
        }
      },
    );
    setState(() {});
  }

  void _startListening() async {
    var locales = await _speechToText.locales();
    await _speechToText.listen(onResult: _onSpeechResult,listenMode: ListenMode.search, localeId: locales[50].localeId,partialResults: true, pauseFor: Duration(seconds: 4));
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    _lastWords = '';
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    if(result.finalResult){
      {
        final openAI = OpenAI.instance.build(
        token: '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',
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
        isLog: true);

        final request = CompleteText(prompt: 'Сравни две строки, используя алгоритм машинного обучения и дай мне ответ в виде процентов от 0 до 100. Первая строка "${result.recognizedWords}". Вторая строка - "${correct_ans}". Дай мне только ответ без пояснений',
                model: 'text-davinci-003', maxTokens: 200);
          
        final ans = await openAI.onCompletion(request: request);
        var percent = ans!.choices[0].text.replaceAll(new RegExp(r'[^0-9]'),'');
        print(int.parse(percent));
      
        if(int.parse(percent) >= 85){
          await AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.scale,
              btnOkText: 'Учиться дальше)',
              btnOkOnPress: () {
                
              },         
              title: "Твоя оценка 5"
              ).show();
        }

        else if(int.parse(percent) >= 60 && int.parse(percent) < 85){
          await AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.scale,
              btnOkText: 'Буду старатсья дальше',
              btnCancelText: 'Посмотреть ошибки',
              btnOkOnPress: () {
                },
              btnCancelOnPress: (){
                

                showDialog(context: context, builder: ((context) {
                  return AlertDialog(
                    backgroundColor: Color.fromRGBO(255, 182, 71, 1),
                    actions: [ElevatedButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text('Буду исправляться'))],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    content: 
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    "Ваше определение - ${result.recognizedWords} \n\nВерное определение - ${widget.checker.data[widget.checker.word_index].descriptions}"
                  ),
                ),);
                }));
              },
                
        title: "Нехватило чуть-чуть)",
        desc: "Твоя оценка 4"
              ).show();
        } else if(int.parse(percent) >=  40 && int.parse(percent) < 60){
          await AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.scale,
              btnOkText: 'Учимся еще)',
              btnCancelText: 'Посмотреть ошибки',
              btnOkOnPress: () {
                },
              btnCancelOnPress: (){
                

                showDialog(context: context, builder: ((context) {
                  return AlertDialog(
                    backgroundColor: Color.fromRGBO(255, 182, 71, 1),
                    actions: [ElevatedButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text('Буду исправляться'))],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    content: 
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    "Ваше определение - ${result.recognizedWords} \n\nВерное определение - ${widget.checker.data[widget.checker.word_index].descriptions}"
                  ),
                ),);
                }));
              },
        title: "Нужно немножко постараться",
        desc: "Твоя оценка 3",
              ).show();
        }

        else {
          await AwesomeDialog(
            context: context,
            title: "Вы пока не знаете этот термин",
            desc: "Твоя оценка 2",
            btnCancelText: 'Посмотреть ошибки',
            btnOkOnPress: () {
                },
            btnCancelOnPress: (){
                

                showDialog(context: context, builder: ((context) {
                  return AlertDialog(
                    backgroundColor: Color.fromRGBO(255, 182, 71, 1),
                    actions: [ElevatedButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text('Буду исправляться'))],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    content: 
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    "Ваше определение - ${result.recognizedWords} \n\nВерное определение - ${widget.checker.data[widget.checker.word_index].descriptions}"
                  ),
                ),);
                }));
              },
          ).show();
        }
         


        // var url = Uri.parse('http://158.160.47.62:5000/${result.recognizedWords}/${correct_ans}');
        // var response = await http.get(url);
        // _lastWords = '';
        // final Map<String, dynamic> data = json.decode(response.body);
        // var persent = data["Ans"]!;
        // int mark = ((persent * 100 ).ceil() / 20).round();
        // if(persent >= 0.8){
        //  await AwesomeDialog(
        //       context: context,
        //       dialogType: DialogType.warning,
        //       animType: AnimType.scale,
        //       btnOkText: 'Учиться дальше',
        //       btnOkOnPress: () {
        //         },
        // title: "Все верно!",
        // desc: "Твоя оценка 5"
        //       ).show();
        // } else if(persent >= 0.6 && persent < 0.8){
        //   await AwesomeDialog(
        //       context: context,
        //       dialogType: DialogType.success,
        //       animType: AnimType.scale,
        //       btnOkText: 'Буду старатсья дальше',
        //       btnCancelText: 'Посмотреть ошибки',
        //       btnOkOnPress: () {
        //         },
        //       btnCancelOnPress: (){
                

        //         showDialog(context: context, builder: ((context) {
        //           return AlertDialog(
        //             backgroundColor: Color.fromRGBO(255, 182, 71, 1),
        //             actions: [ElevatedButton(onPressed: (){
        //               Navigator.of(context).pop();
        //             }, child: Text('Буду исправляться'))],
        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        //             content: 
        //           Container(
        //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        //           child: Text(
        //             "Ваше определение - ${result.recognizedWords} \n\nВерное определение - ${widget.checker.data[widget.checker.word_index].descriptions}"
        //           ),
        //         ),);
        //         }));
        //       },
                
        // title: "Нехватило чуть-чуть)",
        // desc: "Твоя оценка 4"
        //       ).show();
        // } else if(persent >=  0.4 && persent < 0.6){
        //   await AwesomeDialog(
        //       context: context,
        //       dialogType: DialogType.success,
        //       animType: AnimType.scale,
        //       btnOkText: 'Учимся еще)',
        //       btnCancelText: 'Посмотреть ошибки',
        //       btnOkOnPress: () {
        //         },
        //       btnCancelOnPress: (){
                

        //         showDialog(context: context, builder: ((context) {
        //           return AlertDialog(
        //             backgroundColor: Color.fromRGBO(255, 182, 71, 1),
        //             actions: [ElevatedButton(onPressed: (){
        //               Navigator.of(context).pop();
        //             }, child: Text('Буду исправляться'))],
        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        //             content: 
        //           Container(
        //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        //           child: Text(
        //             "Ваше определение - ${result.recognizedWords} \n\nВерное определение - ${widget.checker.data[widget.checker.word_index].descriptions}"
        //           ),
        //         ),);
        //         }));
        //       },
        // title: "Нужно немножео постараться",
        // desc: "Твоя оценка 3"
        //       ).show();
        // }
        // else if(persent <  0.4 ){
        //   await AwesomeDialog(
        //       context: context,
        //       dialogType: DialogType.success,
        //       animType: AnimType.scale,
        //       btnOkText: 'Хорошо',
        //       btnCancelText: 'Посмотреть ошибки',
        //       btnCancelOnPress: (){
                

        //         showDialog(context: context, builder: ((context) {
        //           return AlertDialog(
        //             backgroundColor: Color.fromRGBO(255, 182, 71, 1),
        //             actions: [ElevatedButton(onPressed: (){
        //               Navigator.of(context).pop();
        //               _lastWords = '';
        //             }, child: Text('Буду исправляться'))],
        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        //             content: 
        //           Container(
        //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        //           child: Text(
        //             "Ваше определение - ${result.recognizedWords} \n\nВерное определение - ${widget.checker.data[widget.checker.word_index].descriptions}"
        //           ),
        //         ),);
        //         }));
        //       },
        //       btnOkOnPress: () {
        //         },
        // title: "Необходимо изучить термин",
        // desc: "Твоя оценка 2",
        //       ).show();
        // }
            
          }
    }
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    int _index = widget.checker.word_index;
    context.dependOnInheritedWidgetOfExactType<DataItherited>()!.index = widget.checker.index;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(25, 0, 51, 1),
      endDrawer: Drawer(backgroundColor: const Color.fromRGBO(25, 0, 51, 1), child: ListView.builder(itemCount: widget.checker.data.length, itemBuilder: ((context, index) {
        return ListTile(title: Text(widget.checker.data[index].word, style: TextStyle(color: Colors.white),), leading: IconButton(icon: Icon(Icons.question_mark, color: Color.fromRGBO(9, 192, 250, 1),), onPressed: (){
          AwesomeDialog(context: context, title: widget.checker.data[index].word, 
          desc: widget.checker.data[index].descriptions, btnOkText: "ОК", btnOkOnPress: (){}, btnOkColor: Color.fromRGBO(9, 192, 250, 1)).show();
        }, ),);
      })),),
      appBar: AppBar(
        title: GestureDetector(
          child: AppBarTitle(name: widget.checker.data.length == 0 ? 'Выбрать раздел' : widget.checker.getName(),),
          onTap: () {
            showDialog(context: context, builder: ((context) {
              return Container(
            color: Color.fromARGB(11, 23, 28, 38),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 20,),
                  GestureDetector(
                    child: Container(child: MainScreenContainersWidgets(imageSrc: "lib/Resources/assets/images/politic.jpeg",)),
                    onTap: () {
                      setState(() {
                        widget.checker.index= 0;
                        widget.checker.update();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 20,),
                  GestureDetector(
                    child: Container(child: MainScreenContainersWidgets(imageSrc: "lib/Resources/assets/images/economy.jpeg")),
                    onTap: () {
                      setState(() {
                        widget.checker.index= 1;
                        widget.checker.update();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 20,),
                  GestureDetector(
                    child: Container(child: MainScreenContainersWidgets(imageSrc: "lib/Resources/assets/images/socium.jpeg")),
                    onTap: () {
                      setState(() {
                        widget.checker.index= 2;
                        widget.checker.update();
                      });
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 20,),
                  GestureDetector(
                    child: Container(child: MainScreenContainersWidgets(imageSrc: "lib/Resources/assets/images/soul.png",)),
                    onTap: () {
                      setState(() {
                        widget.checker.index= 3;
                        widget.checker.update();
                      });
                      Navigator.pop(context);
                    },
                  ),
              ],
            )),
          );
            }));
          },
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(25, 0, 51, 1),
      ),
      body: Center(
        child: widget.checker.data.isNotEmpty ? AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child,);
          },
          child: FlipCard(
            key: ValueKey(_index),
            front: Container(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width - 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromRGBO(255, 182, 71, 1),
              boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 5,
                offset: Offset(4, 3), // Shadow position
              ),
            ],
              ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: _lastWords.isEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                      "${widget.checker.data.isEmpty ? "Выберете сверху нужный вам раздел" : widget.checker.data[widget.checker.word_index].word} - это ?", style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
                      maxLines: 1,
                  ),
                  Text(_speechToText.isNotListening ? " Нажмите на микрофон, чтобы дать определение. \n\n Нажмите на картчоку, чтобы посмотреть подсказку." : _lastWords, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),),
                ],
              ),
            ),
            ), back: Container(
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width - 100,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromRGBO(255, 182, 71, 1),
              boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 5,
                offset: Offset(4, 3), // Shadow position
              ),
            ],
              ), child: Text(widget.checker.data[widget.checker.word_index].descriptions),),)
        ) 
        : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.ltr,
                children: [
                  Text(widget.checker.data.isEmpty ? "Выберете сверху нужынй вам раздел" : widget.checker.data[widget.checker.word_index].word, style: const TextStyle(color: Colors.white),),
                  Text(_lastWords, style: TextStyle(color: Colors.black),),
                ],
              ),
            ),
          ),
      ),


//descriptions
      persistentFooterButtons: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: const Size(50, 50),
                  backgroundColor: Color.fromRGBO(9, 192, 250, 1)
                ),
              onPressed: () {
                if (widget.checker.word_index > 0) {
                  setState(() {
                    widget.checker.word_index -= 1;
                    _index -= 1;
                  });
                }
              },
              child: const Icon(Icons.navigate_before)),
            ElevatedButton(onPressed: (){
              if(widget.checker.data.isNotEmpty){
                correct_ans = widget.checker.data[widget.checker.word_index].descriptions;
                _speechToText.isNotListening ? _startListening() : _stopListening();
              }
            }, child: Icon(Icons.mic),  style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: const Size(50, 50),
                  backgroundColor: _speechToText.isNotListening ? Color.fromRGBO(9, 192, 250, 1) : Color.fromARGB(255, 218, 30, 30)),),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: const Size(50, 50),
                  backgroundColor: Color.fromRGBO(9, 192, 250, 1)),
              onPressed: () {

                if(widget.checker.data.isNotEmpty){
                  widget.checker.word_index = Random().nextInt(widget.checker.data.length);
                  setState(() {});
                }
                
              },
              child: const Icon(Icons.loop)),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: const Size(50, 50),
                  backgroundColor: Color.fromRGBO(9, 192, 250, 1)),
              onPressed: () {
                if (widget.checker.word_index < widget.checker.data.length - 1) {
                  setState(() {
                    widget.checker.word_index += 1;
                  });
                }
              },
              child: const Icon(Icons.navigate_next))
        ])
      ],
    );
  }
}


