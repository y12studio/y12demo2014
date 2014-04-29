// Copyright (c) 2014, y12studio.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Apache license.
library survey_test;

import 'package:unittest/unittest.dart';
import 'package:di/di.dart';
import 'package:angular/angular.dart';
import 'package:angular/mock/module.dart';

import '../web/survey.dart';

main() {

  setUp(() {
    setUpInjector();
    module((Module m) => m.install(new MyAppModule()));
  });
  tearDown(tearDownInjector);

  group('survery app module', () {

    test('should load surveys', async(inject((Injector injector, MockHttpBackend backend) {
      backend.expectGET('recipes.json').respond('[{"name": "test1"}]');
      backend.expectGET('categories.json').respond('["c1"]');

      var controller = injector.get(SurveyController);
      expect(controller.surveys, isEmpty);

      microLeap();
      backend.flush();
      microLeap();

      expect(controller.surveys, isNot(isEmpty));
    })));

    test('should select survey', async(inject((Injector injector,
                                                   MockHttpBackend backend) {
          backend.expectGET('recipes.json').respond('[{"name": "test1"}]');
          backend.expectGET('categories.json').respond('["c1"]');

          var controller = injector.get(SurveyController);
          expect(controller.surveys, isEmpty);

          microLeap();
          backend.flush();
          microLeap();

          var survey = controller.surveys[0];
          controller.selectSurvey(survey);
          expect(controller.selectedSurvey, same(survey));
        })));
    
  });
}
