// Copyright (c) 2014, y12studio.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Apache license.
import 'package:bloodless/server.dart' as app;
import 'package:logging/logging.dart';

final Logger _logger = new Logger("dartbloodless_server");

@app.Route("/hello")
helloWorld() => "Hello, World!";

@app.Interceptor(r'/.*')
handleResponseHeader() {
  app.request.response.headers.add("Access-Control-Allow-Origin", "*");
  app.chain.next();
}

@app.Interceptor(r'/.*')
adminBasicAuthFilter(){
  if(app.authenticateBasic("user", "pass",realm:"DartSurvey1404",abortOnFail:true)){
    app.chain.next();
  }
}

@app.Route("/user/:username")
helloUser(String username) => "hello $username";

main() {
  app.setupConsoleLog();
  // mapping to build directory.
  app.start(port: 8080, staticDir: "../build/web", indexFiles: ["dartsurvey1404.html"]);
}
