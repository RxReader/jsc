import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jsx/src/core/js_context_group.dart';

void main() {
  assert(Platform.isMacOS);
  test('JSContextGroup.create', () {
    final JSContextGroup group = JSContextGroup.create();
    final JSContextGroup groupRetain = group.retain();
    expect(groupRetain, group);
    groupRetain.release();
    group.release();
  });
}
