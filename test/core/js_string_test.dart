import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jsc/src/core/js_string.dart';

void main() {
  assert(Platform.isMacOS);
  test('JSString.fromString', () {
    final JSString string = JSString.fromString('123');
    final JSString stringRetain = string.retain();
    expect(string.length, 3);
    expect(string.string, '123');
    expect(string, stringRetain);
    string.release();
    stringRetain.release();
  });
}
