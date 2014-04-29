import 'dart:html';
import 'package:angular/application_factory.dart';

main() {  
  applicationFactory().run();
//  querySelector("#sample_text_id")
//      ..text = "Click me!"
//      ..onClick.listen(reverseText);
}

void reverseText(MouseEvent event) {
  var text = querySelector("#sample_text_id").text;
  var buffer = new StringBuffer();
  for (int i = text.length - 1; i >= 0; i--) {
    buffer.write(text[i]);
  }
  querySelector("#sample_text_id").text = buffer.toString();
}
