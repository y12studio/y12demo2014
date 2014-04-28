import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:convert';
import 'package:js/js.dart' as js;
import 'package:chart/chart.dart';
import 'package:quiver/async.dart';
import 'package:simplot/simplot.dart';

class SurveyItem {
  String id;
  String question;
  List options;
  SurveyItem(this.id, this.question, this.options);
  SurveyItem.forMap(Map m) {
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

  List surveys = toObservable([]);

  ClickCounter.created(): super.created() {
    FutureGroup group = new FutureGroup();
    group.add(HttpRequest.getString("survey1.json"));
    group.add(HttpRequest.getString("survey2.json"));
    group.future.then((results) {
      this.surveys.add(JSON.decode(results[0]).map((m) => new SurveyItem.forMap(m)));
      this.surveys.add(JSON.decode(results[1]).map((m) => new SurveyItem.forMap(m)));
    });
  }

  enteredView() {
    super.enteredView();
    // js.context in polymer issue?
    //_drawGoogleChartVisualization();

    // dart2js color issue.
    //_drawChartJs();
    
    // failure dart2js
    //_drawSimplot();
  }
  
  _drawSimplot(){
    // failure dart2js
    var data = [1, 3, 2, 5, 6.3, 17, 4];
    var elem = this.shadowRoot.querySelector("#simPlotQuad");
   // var elem2 = $['#simPlotQuad'];
    var dataPlot = plot(data,shadow:elem);
  }

  // ref https://github.com/dart-lang/js-interop/blob/master/example/google-chart/bubblechart.dart
  _drawGoogleChartVisualization() {
    // failure
    var google = js.context.google;
    var gviz = google.visualization;

    // Create and populate the data table.
    var listData = [['ID', 'Life Expectancy', 'Fertility Rate', 'Region', 'Population'], ['CAN', 80.66, 1.67, 'North America', 33739900], ['DEU', 79.84, 1.36, 'Europe', 81902307], ['DNK', 78.6, 1.84, 'Europe', 5523095], ['EGY', 72.73, 2.78, 'Middle East', 79716203], ['GBR', 80.05, 2, 'Europe', 61801570], ['IRN', 72.49, 1.7, 'Middle East', 73137148], ['IRQ', 68.09, 4.77, 'Middle East', 31090763], ['ISR', 81.55, 2.96, 'Middle East', 7485600], ['RUS', 68.6, 1.54, 'Europe', 141850000], ['USA', 78.09, 2.05, 'North America', 307007000]];

    var arrayData = js.array(listData);

    var tableData = gviz.arrayToDataTable(arrayData);

    var options = js.map({
      'title': 'Correlation between life expectancy, ' 'fertility rate and population of some world countries (2010)',
      'hAxis': {
        'title': 'Life Expectancy'
      },
      'vAxis': {
        'title': 'Fertility Rate'
      },
      'bubble': {
        'textStyle': {
          'fontSize': 11
        }
      }
    });

    // Create and draw the visualization.
    var chart = new js.Proxy(gviz.BubbleChart, querySelector('#visualization'));
    chart.draw(tableData, options);
  }

  _drawChartJs() {
    Line chart2 = new Line({
      'labels': ["1", "2", "3", "4", "5", "6"],
      'datasets': [{
          'fillColor': "rgba(123,244,220,0.5)",
          'strokeColor': "rgba(220,220,220,1)",
          'pointColor': "rgba(220,220,220,1)",
          'pointStrokeColor': "#afafaf",
          'data': [[null, 20, 16], null, [null, 10, null], [null, 10, null], 24, [null, 17, null, 25, null, 20, 14, null, 23, 25, 40, 20, null]]
        }]

    }, {
      'animationEasing': 'easeOutElastic',
      'animation': false,
      'bezierCurve': true,
    });

    DivElement container2 = new DivElement();
    container2.style.height = '400px';
    container2.style.width = '100%';
    $['chart'].children.add(container2);
    chart2.show(container2);
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
