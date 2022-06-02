import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jsc/src/bindings/js_base.dart';
import 'package:jsc/src/bindings/js_context_ref.dart';

void main() {
  assert(Platform.isMacOS);
  test('JSContextGroupCreate', () {
    final JSContextGroupRef group = JSContextGroupCreate();
    try {
      if (kDebugMode) {
        print('group: $group');
      }
      expect(group.address != nullptr.address, true);
    } finally {
      JSContextGroupRelease(group);
    }
  });
  test('JSContextGroupRetain', () {
    final JSContextGroupRef group = JSContextGroupCreate();
    final JSContextGroupRef groupRetain = JSContextGroupRetain(group);
    try {
      if (kDebugMode) {
        print('group: $group');
        print('groupRetain: $groupRetain');
      }
      expect(group.address != nullptr.address, true);
      expect(groupRetain.address != nullptr.address, true);
      expect(groupRetain.address == group.address, true);
    } finally {
      JSContextGroupRelease(group);
    }
  });
}
