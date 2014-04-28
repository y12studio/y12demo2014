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
  // 
  _drawSimplot(){
      // failure dart2js
      var data = [1, 3, 2, 5, 6.3, 17, 4];
      var elem = this.shadowRoot.querySelector("#simPlotQuad");
      // failure dart2js
      var dataPlot = plot(data,shadow:elem);
      //var dataPlot = plotInShadow(data);
    }
  
  // test
  Plot2D plotInShadow(List y1, {
      List xdata: null,
      List y2: null,
      List y3: null,
      List y4: null,
      String style1: 'linepts',
      String style2: null,
      String style3: null,
      String style4: null,
      String color1: 'black',
      String color2: 'ForestGreen',
      String color3: 'Navy',
      String color4: 'FireBrick',
      int linewidth: 2,
      int range: 1,
      int index: 1,
      Element shadow: null,
      String container: '#simPlotQuad'}) {

    if (y1 == null || y1.isEmpty) throw new ArgumentError("No data to be plotted.");

    final bool large = true;
    final int _gphSize = 600;
    final int _border = 80;
    final int _pwidth = _gphSize;
    final int _scalePlot = large ? 2 : range;
    final int _pheight = range == 1 ? _gphSize : (_gphSize * 1.5 ~/ _scalePlot);
    // Testing support for shadow DOM.
    Element graphContainer = canvasContainer;
    var _plotCanvas = canvas;
    _plotCanvas.attributes = ({
      "id": "simPlot$index",
      "class": "simPlot",
      "width": "$_pwidth",
      "height": "$_pheight",
    });
    ctx
      ..fillStyle = 'white'
      ..fillRect(0, 0, _pwidth, _pheight)
      ..fillStyle = 'black';

    //If no xdata was passed, create a row vector
    //based on the length of y1.
    if (xdata == null) {
      if (style1 == 'data') {
        xdata = new List.generate(y1.length, (var index) =>
            index + 1, growable:false);
      } else {
        xdata = new List.generate(y1.length, (var index) =>
            index, growable:false);
      }
    } else if (style1 == 'data') {
      xdata = new List.generate(y1.length, (var index) =>
          index + xdata[0], growable:false);
    }

    //Build a HashMap of the all the y axis data.
    var _ydata = new LinkedHashMap();
    _ydata["y1"] = y1;
    _ydata["y2"] = y2;
    _ydata["y3"] = y3;
    _ydata["y4"] = y4;

    //Build a HashMap of the all the plot style for each data set.
    var _style = new LinkedHashMap();
    _style["y1"] = style1;
    _style["y2"] = style2 == null ? style1 : style2;
    _style["y3"] = style3 == null ? style1 : style3;
    _style["y4"] = style4 == null ? style1 : style4;

    //Build a HashMap of the corresponding colors for the plots.
    var _color = new LinkedHashMap();
    _color["y1"] = color1;
    _color["y2"] = color2;
    _color["y3"] = color3;
    _color["y4"] = color4;

    //Return the Plot2D object.
    return new Plot2D(ctx, _ydata, xdata, _color, _style, _pwidth, _pheight,
        linewidth);
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
