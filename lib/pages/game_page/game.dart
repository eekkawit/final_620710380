import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_620710380/pages/form/api.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Future<List> _data = _getQuiz();
  var _count = 0;
  var _word = "";
  var _isCorrect = false;
  var _inCorrect = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(_count < 5)
                    FutureBuilder<List>(
                      future: _data,
                      builder: (context, snapshot){
                        if(snapshot.connectionState != ConnectionState.done){
                          return const CircularProgressIndicator();
                        }

                        if(snapshot.hasData) {
                          var data = snapshot.data!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(data[_count]['image'], height: 270.0,),
                              for(var i=0;i<data[_count]['choice_list'].length;++i)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        if(data[_count]['choice_list'][i] == data[_count]['answer']){
                                          _word = "เก่งมากครับ";
                                          _isCorrect = true;
                                          Timer(Duration(seconds: 1), () {
                                            setState(() {
                                              _count++;
                                              _word = "";
                                            });
                                          });

                                        }else{
                                          setState(() {
                                            _word = "ยังไม่ถูก ลองใหม่นะครับ";
                                            _isCorrect = false;
                                            _inCorrect++;
                                          });
                                        }
                                      });
                                    },
                                    child: Container(
                                        height: 40.0,
                                        color: Colors.deepPurple,
                                        child: Center(child: Text(data[_count]['choice_list'][i], style: TextStyle(fontSize: 25.0),))
                                    ),
                                  ),
                                )
                            ],
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("จบเกม" , style: TextStyle(fontSize: 40.0),),
                        Text("ทายผิด $_inCorrect ครั้ง" , style: TextStyle(fontSize: 26.0),),
                        ElevatedButton(
                          onPressed: (){
                            setState(() {
                              _count = 0;
                              _inCorrect = 0;
                              _data = _getQuiz();
                            });
                          },
                          child: Container(
                              height: 40.0,
                              width: 130.0,
                              color: Colors.grey,
                              child: Text("เริ่มเกมใหม่", textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0),)
                          ),
                        )
                      ],
                    ),
                  if(_isCorrect)
                    Text(_word, style: TextStyle(fontSize: 26.0, color: Colors.pinkAccent),)
                  else
                    Text(_word, style: TextStyle(fontSize: 26.0, color: Colors.green.shade400),)
                ],
              ),
            )
        ),
      ),
    );
  }

  Future<List> _getQuiz() async{
    final url = Uri.parse('https://cpsu-test-api.herokuapp.com/quizzes');
    var reply = await http.get(url, headers: {'id': '620710380'},);

    var json = jsonDecode(reply.body);
    var apiResult = Api.fromJson(json);
    List data = apiResult.data;
    print(data);
    return data;
  }
}