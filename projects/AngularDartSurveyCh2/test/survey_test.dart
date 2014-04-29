// Copyright (c) 2014, y12studio.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Apache license.
library survey_test;

import 'package:unittest/unittest.dart';
import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';

import '../web/survey.dart';

final String jsonTarget ="""
[
 {
   "name":"SurveyName1",
   "category":"Food",
   "rating":10,
   "questions":[
        { "title":"QuestionTitle1",
          "choices": ["Sure", "XX", "Y1","O1"]
        },
        { "title":"QuestionTitle12",
          "choices": ["Sure", "YY", "Y2","O2"]
        },
        { "title":"QuestionTitle3",
          "choices": ["Sure", "ZZ", "Y3","O3"]
        }
        ]
 }]
""";

final String jsonTargetCa="""
[
  "Food",
  "Game",
  "Movie"
]
""";

main() {

  setUp(() {
    setUpInjector();
    module((Module m) => m.install(new MyAppModule()));
  });
  tearDown(tearDownInjector);

  group('[GROUP]survery app module', () {

    test('[TEST]should load surveys', async(inject((Injector injector, MockHttpBackend backend) {
      
      backend.expectGET('categories.json').respond(jsonTargetCa);
      backend.expectGET('surveys.json').respond(jsonTarget);

      var controller = injector.get(SurveyController);
      expect(controller.surveys, isNull);

      microLeap();
      backend.flush();
      microLeap();
      
      expect(controller.surveys.length, 1);

      expect(controller.surveys, isNot(isEmpty));
    })));

    test('[TEST]should select survey', async(inject((Injector injector,
                                                   MockHttpBackend backend) {
          backend.expectGET('categories.json').respond(jsonTargetCa);
          backend.expectGET('surveys.json').respond(jsonTarget);
            
          var controller = injector.get(SurveyController);
          expect(controller.surveys, isNull);

          microLeap();
          backend.flush();
          microLeap();

          var survey = controller.surveys[0];
          controller.selectSurvey(survey);
          expect(controller.selectedSurvey, same(survey));
        })));
    
  });
}
