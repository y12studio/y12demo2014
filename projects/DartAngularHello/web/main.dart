import 'dart:html' as dom;
import 'package:js/js.dart' as js;
import 'dart:math';
import 'package:angular/application_factory.dart';
import 'package:angular/angular.dart';

var rng = new Random();

// ref http://stackoverflow.com/questions/23079390/google-chart-is-shown-ngdirective-but-not-ngcomponent
printPlot(dom.Element element, String title) {
  var gviz = js.context.google.visualization;

  var gTableData = new js.Proxy(gviz.DataTable);
  gTableData.addColumn('number', 'Size');
  gTableData.addColumn('number', 'Counts');

  new Iterable.generate(11).forEach((v){
    gTableData.addRow(js.array([v, v*rng.nextInt(105)]));    
  });

  var options = js.map({
      'title': title
  });

  // Create and draw the visualization.
  var chart = new js.Proxy(gviz.ScatterChart, element);
  chart.draw(gTableData, options);
  print("Succesfully printed plot for $title");
}

@Decorator(selector: '[my-googlechart]')
class MyDirective {
  final dom.Element element;
  final Scope scope;
  MyDirective(this.element,this.scope) {
    js.context.google.load('visualization', '1', js.map({
        'packages': ['corechart'],
        'callback': (() => printPlot(element, 'AngularDart Decorator Graph'))
    }));
    
    // http://stackoverflow.com/questions/22151427/how-to-communicate-between-angular-dart-controllers/22151723#22151723
    scope.on('username-change').listen((ScopeEvent e) => myCallback(e));
  }
  
  myCallback(ScopeEvent e) {
    // this.name = e.data;
    printPlot(element, 'AngularDart Decorator Graph 2');
  }
}


@Controller(selector: '[my-hello]',publishAs: 'hello')
class HelloWorld{
  String name;
  int age;
  final Scope scope;
  HelloWorld(this.scope);
  
  void foo() {
    print('Age $age');
    // Sender
    scope.emit("username-change", "emit");
  }
}

@Formatter(name: 'capitalize')
class Capitalize {
  call(val) {
    if (val is String) {
      return (val.length <= 1) ? val.toUpperCase() :
        val[0].toUpperCase() +
        val.substring(1).toLowerCase();
    }
    return val;
  }
}

main() {  
  applicationFactory()
    ..addModule(new Module()..bind(HelloWorld)..bind(MyDirective)..bind(Capitalize))
     ..run();
}