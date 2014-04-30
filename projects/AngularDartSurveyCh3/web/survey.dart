// Copyright (c) 2014, y12studio.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Apache license.
library survey_main;
import 'package:angular/application_factory.dart';
import 'package:angular/angular.dart';
import 'package:quiver/async.dart';
import 'package:crypto/crypto.dart';


@Controller(selector: '[survey]', publishAs: 'ctrl')
class SurveyController {
  final Http _http;
  Survey selectedSurvey;
  List<Survey> surveys;
  List<String> categories;

  SurveyController(this._http) {
    _loadData();
  }

  void selectSurvey(Survey s) {
    selectedSurvey = s;
  }

  _loadData() {
    new FutureGroup()
        ..add(_http.get('categories.json'))
        ..add(_http.get('surveys.json'))
        ..future.then((results) {
          print(results[0].data);
          categories = results[0].data;
          surveys = results[1].data.map((d) => new Survey.fromJson(d)).toList();
        });

  }
}

class Question {
  String title;
  List<String> choices;
  Question(this.title, this.choices);

  String get qid => 'question${this.hashCode}';

  Map<String, dynamic> toJson() => <String, dynamic> {
    "title": title,
    "choices": choices
  };

  Question.fromJson(Map<String, dynamic> json): this(json['title'], json['choices']);
}

class Survey {
  String name;
  String category;
  List<Question> questions;
  int rating;
  Survey(this.name, this.category, this.questions, this.rating);
  Map<String, dynamic> toJson() => <String, dynamic> {
    "name": name,
    "category": category,
    "questions": questions,
    "rating": rating
  };

  Survey.fromJson(Map<String, dynamic> json): this(json['name'], json['category'], json['questions'].map((m) => new Question.fromJson(m)).toList(), json['rating']);
}

class MyAppModule extends Module {
  MyAppModule() {
    bind(SurveyController);
  }
}

void main() {
  applicationFactory().addModule(new MyAppModule()).run();
}
