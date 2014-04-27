// Copyright (c) 2014, y12studio.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Apache license.
import 'package:bloodless/server.dart' as app;
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:utf/utf.dart';
import 'package:logging/logging.dart';

final Logger _logger = new Logger("dartbloodless_server");

@app.Route("/hello")
helloWorld() => "Hello, World!";

@app.Interceptor(r'/adminsess/.*')
adminSessionFilter() {
  if (app.request.session["username"] != null) {
    app.chain.next();
  } else {
    app.chain.interrupt(statusCode: HttpStatus.UNAUTHORIZED);
    //or app.redirect("/login.html");
  }
}

@app.Interceptor(r'/.*')
handleResponseHeader() {
  app.request.response.headers.add("Access-Control-Allow-Origin", "*");
  app.chain.next();
}

@app.Route("/adminbasic")
adminbasic() => "Hello, World admin basic!";


authenticateBasic(String realm, String username, String password){
  bool r = false;
  if (app.request.headers[HttpHeaders.AUTHORIZATION] != null) {
    String authorization = app.request.headers[HttpHeaders.AUTHORIZATION][0];
    List<String> tokens = authorization.split(" ");
    String auth = CryptoUtils.bytesToBase64(encodeUtf8("$username:$password"));
    if ("Basic" == tokens[0] && auth == tokens[1]) {
      r = true;
    }
  }
  if (r) {
    app.chain.next();
  } else {
    app.request.response.headers.add(HttpHeaders.WWW_AUTHENTICATE, 'Basic realm="$realm"');
    app.chain.interrupt(statusCode: HttpStatus.UNAUTHORIZED);
  }  
}

@app.Interceptor('/adminbasic')
adminBasicAuthFilter() {
  String user="user";
  String pass="pass";
  authenticateBasic("BloodlessRealm",user, pass);
}

@app.Route("/user/:username")
helloUser(String username) => "hello $username";

main() {
  app.setupConsoleLog();
  // mapping to build directory.
  app.start(port: 8080, staticDir: "../build/web", indexFiles: ["dartsurvey1404.html"]);
}
