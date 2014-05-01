// Copyright (c) 2014, y12studio.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Apache license.
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'test_server.dart' as ts;
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';

testFoo() {
  group('outer', () {
    test('outer test 1', () => print('outer test 1'));
    setUp(() => print('outer setup 1'));
    tearDown(() => print('outer teardown 1'));
    test('outer test 2', () => expect(0, 0));
    setUp(() => print('outer setup 2'));
    tearDown(() => print('outer teardown 2'));
    test('outer test 3', () => print('outer test 3'));
    group('inner', () {
      test('inner test 1', () => print('inner test 1'));
      setUp(() => print('inner setup 1'));
      tearDown(() => print('inner teardown'));
      test('inner test 2', () => () => expect(-100, isNegative));
      setUp(() => print('inner setup 2'));
      test('inner test 3', () => print('inner test 3'));
      setUp(() => print('inner setup 3'));
    });
  });
}

testServer2(int port, String title, String url) {

  Completer _completer = new Completer();

  _testServerPort(HttpServer s) {
    expect(s.port, port);
  }

  _testGet(Response resp) {
    expect(resp.body, "Hello World");
    expect(resp.statusCode, 200);
  }

  ts.startApp(port).then((server) {
    _testServerPort(server);
    http.get(url).then((resp) {
      _testGet(resp);
      _completer.complete();
    });
  });


  test(title, () {
    expect(_completer.future, completes);
  });

}

testServer1(int port) {

  _testServerPort(HttpServer s) {
    expect(s.port, port);
  }

  test('Running Server', () {
    Future future = ts.main();
    future.then((HttpServer server) {
      _testServerPort(server);
    });
    expect(future, completes);
  });
}

main() {
  useVMConfiguration();
  testFoo();
  testServer1(8080);
  testServer2(8081, 'Test Http Get', 'http://127.0.0.1:8081/hello');

  // test 3

  var f3 = ts.testServerGet(8082, 'http://127.0.0.1:8082/hello2', (resp) {
    expect(resp.body, "Hello World2");
    expect(resp.statusCode, 200);
  }, (server) {
    expect(server.port, 8082);
  });

  test('Test Http Get ver3', () {
    expect(f3, completes);
  });
  
  var f4 = ts.testServerGet(8083, 'http://127.0.0.1:8083/hello', (resp) {
    expect(resp.body, "Hello World");
    expect(resp.statusCode, 200);
  });

  test('Test Http Get ver4', () {
    expect(f4, completes);
  });
  
}
