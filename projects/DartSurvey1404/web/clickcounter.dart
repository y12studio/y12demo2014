import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:convert';
import 'package:quiver/async.dart';
import 'dart:collection';
import 'packages/simplot/simplot.dart';

//
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
  var canvas;
  var ctx;
  var canvasContainer;

  ClickCounter.created(): super.created() {
    FutureGroup group = new FutureGroup();
    group.add(HttpRequest.getString("survey1.json"));
    group.add(HttpRequest.getString("survey2.json"));
    group.future.then((results) {
      this.surveys.add(JSON.decode(results[0]).map((m) => new SurveyItem.forMap(m)));
      this.surveys.add(JSON.decode(results[1]).map((m) => new SurveyItem.forMap(m)));
    });

    // get canvas and context
   canvasContainer = shadowRoot.querySelector('chart');
    canvas = shadowRoot.querySelector('canvas');
    ctx = canvas.getContext('2d') as CanvasRenderingContext2D // makes type checker happy
        ..fillStyle = "#afafaf";
  }

  enteredView() {
    super.enteredView();
    //_drawCanvas();
    _drawSimplot();
  }
  
  // simplot function
  _drawSimplot(){
      // failure dart2js
      var data = [1, 3, 2, 5, 6.3, 17, 4];
      var elem = shadowRoot.querySelector("#simPlotQuad");
      // failure dart2js
      // fix by copy simplot to local lib directory.
      var dataPlot = plot(data,shadow:elem);
    }

  void _drawCanvas() {
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.beginPath();
    int index = 0;
    int spacing = 10;
    for (num dataPoint in [1, 2, 3, 4, 15, 10]) {
      ctx.lineTo(index * spacing, canvas.height / 2 + dataPoint * spacing);
      index++;
    }
    ctx.stroke();
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
