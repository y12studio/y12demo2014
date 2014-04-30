import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'test_server.dart' as test_server;
import 'dart:io';

testFoo() {
  group('outer', () {
    test('outer test 1', () => print('outer test 1'));
    setUp(() => print('outer setup 1'));
    tearDown(() => print('outer teardown 1'));
    test('outer test 2',  ()=>expect(0, equals(0)));
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

testServer() {
  group("Running Server", () {
    var server;
    setUp(() {
      return test_server.main()..then((s) {
            server = s;
          });
    });
    // tests go here...


    test("GET /hello responds successfully", () {
      new HttpClient().getUrl(Uri.parse("http://localhost:8080/hello")).then((request) {
        // request.write('{"foo": 42}');
        return request.close();
      }).then(expectAsync1((resp) {
        expect(resp.statusCode, 200);
      }));
    });

  });
}

main() {
  useVMConfiguration();
  testFoo();
  testServer();
}
