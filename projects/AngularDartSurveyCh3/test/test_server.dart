// Copyright (c) 2014, y12studio.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Apache license.
library test_server;
import 'package:bloodless/server.dart' as app;
import 'package:logging/logging.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';

final Logger _logger = new Logger("dartbloodless_server");

@app.Route("/hello")
helloWorld() => "Hello World";

@app.Route("/hello2")
helloWorld2() => "Hello World2";

@app.Interceptor(r'/.*')
handleResponseHeader() {
  app.request.response.headers.add("Access-Control-Allow-Origin", "*");
  app.chain.next();
}

Future startApp(int port){
  //app.setupConsoleLog();
  print('Start port $port');
  return app.start(port: port, staticDir: "../build/web", indexFiles: ["survey.html"]); 
}


Future testServerGet(int port, String url, testGetResp(Response resp), [testServerReady(HttpServer server)]) {
  Completer _completer = new Completer();
  startApp(port).then((server) {
    if(testServerReady!=null){
      testServerReady(server);      
    }
    http.get(url).then((resp) {
      testGetResp(resp);
      _completer.complete();
    });
  });
  return _completer.future;
}

main() {
  return startApp(8080);
}
