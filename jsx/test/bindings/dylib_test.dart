import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jsx/src/bindings/dylib.dart';

void main() {
  assert(Platform.isMacOS);
  test('dylib', () {
    if (kDebugMode) {
      print('jscLib: $jscLib');
    }
    expect(jscLib != null, true);
  });
}
