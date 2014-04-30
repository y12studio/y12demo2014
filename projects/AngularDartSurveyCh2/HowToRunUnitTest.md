## Headless Browser Unit Tests

[browser_unittest.dart/.travis.yml at master · Mixbook/browser_unittest.dart](https://github.com/Mixbook/browser_unittest.dart/blob/master/.travis.yml)


## Karma-dart on Win7_x64

[karma-runner/karma-dart](https://github.com/karma-runner/karma-dart)

[How do I run tests with Karma? · Issue #16 · angular/angular.dart](https://github.com/angular/angular.dart/issues/16)

[Installing Node and Karma for AngularJS Testing on Windows](http://matthewodette.com/installing-node-and-karma-for-angularjs-testing-on-windows/)


```
// install nodejs
> cd y12demo2014/projects/AngularDartSurveyCh2
> cat package.json
{
  "name": "angular.dart",
  "dependencies": {
    "karma": "^0.11.14",
    "karma-dart": "^0.2.6",
    "karma-chrome-launcher": "*",
    "karma-firefox-launcher": "*",
    "karma-junit-reporter": "*"
  },
  "devDependencies": {
    "karma-chrome-launcher": "^0.1.3"
  }
}
> npm install
> npm install -g karma-dart
> karma_run.bat --p 9876
Dart VM version: 1.3.3 (Wed Apr 16 12:40:55 2014) on "windows_ia32"
Karma version: 0.11.14
INFO [karma]: Karma v0.11.14 server started at http://localhost:9876/
INFO [watcher]: Changed file "C:/y12/github/y12demo2014/projects/AngularDartSurv
eyCh2/test/survey_test.dart".
// dart editor RUN>Launcher Dartium http://localhost:9876/debug.html.
```

test result

```
[5428:3640:0429/235952:ERROR:navigation_entry_screenshot_manager.cc(164)] Invalid entry with unique id: 14

unittest-suite-wait-for-done (http://localhost:9876/debug.html:22)
[Food, Game, Movie] (http://localhost:9876/debug.html:22)
SUCCESS [GROUP]survery app module [TEST]should load surveys (http://localhost:9876/debug.html:28)
[Food, Game, Movie] (http://localhost:9876/debug.html:22)
SUCCESS [GROUP]survery app module [TEST]should select survey (http://localhost:9876/debug.html:28)

```
