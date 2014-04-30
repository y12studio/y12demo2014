// Copyright (c) 2014, y12studio.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Apache license.
library test_server;
import 'package:bloodless/server.dart' as app;
import 'package:logging/logging.dart';
import 'dart:io';
import 'dart:async';

final Logger _logger = new Logger("dartbloodless_server");

@app.Route("/hello")
helloWorld() => "Hello, World!";

@app.Interceptor(r'/.*')
handleResponseHeader() {
  app.request.response.headers.add("Access-Control-Allow-Origin", "*");
  app.chain.next();
}

main() {
  // app.setupConsoleLog();
  // mapping to build directory.
  return app.start(port: 8080, staticDir: "../build/web", indexFiles: ["survey.html"]);

}
