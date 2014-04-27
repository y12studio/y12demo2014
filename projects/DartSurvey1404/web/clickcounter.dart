import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:convert';

String rawjson1 = """[
{"id":"S001","question":"QuesionA","options": ["非常確定", "確定", "不是很確定"]},
{"id":"S002","question":"QuesionB","options": ["非常確定","Item3", "確定", "不是很確定"]},
{"id":"S003","question":"QuesionC","options": ["非常確定", "確定", "不是很確定"]},
{"id":"S004","question":"QuesionD","options": ["非常確定", "確定", "Item2","不是很確定"]},
{"id":"S005","question":"QuesionE","options": ["非常確定A", "確定V", "不是很確定D"]}
]""";


String rawjson2 = """[
{"id":"S101","question":"QuesionA1","options": ["非常確定1", "確定", "不是很確定"]},
{"id":"S102","question":"QuesionB1","options": ["非常確定1","Item3", "確定", "不是很確定"]},
{"id":"S103","question":"QuesionC1","options": ["非常確定1", "確定", "不是很確定"]},
{"id":"S104","question":"QuesionD1","options": ["非常確定2", "確定", "Item2","不是很確定"]},
{"id":"S105","question":"QuesionE1","options": ["非常確定A", "確定V", "不是很確定D"]}
]""";

class SurveyItem {
  String id;
  String question;
  List options;
  SurveyItem(this.id, this.question, this.options);
  SurveyItem.forMap(Map m){
    this.id = m['id'];
    this.question = m['question'];
    this.options = m['options'];
  }
}

/**
 * A Polymer click counter element.
 */
@CustomTag('click-counter')
class ClickCounter extends PolymerElement {
  @published
  int count = 0;
  
  @observable
  String op;

  final List survey1 = JSON.decode(rawjson1).map((m) => new SurveyItem.forMap(m)).toList();
  final List survey2 = JSON.decode(rawjson2).map((m) => new SurveyItem.forMap(m)).toList();

  ClickCounter.created(): super.created() {
  }

  enteredView() {
  }

  void updateModel(Event e, var detail, Node target) {
    var input = (e.target as InputElement);
    print('${input.name} : ${input.value}');
    //print( encode( maritalStatus ) );

  }


  void increment() {
    count++;
  }
}
