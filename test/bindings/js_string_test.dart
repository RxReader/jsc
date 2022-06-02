import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jsc/src/bindings/js_base.dart';
import 'package:jsc/src/bindings/js_string_ref.dart';

void main() {
  assert(Platform.isMacOS);
  test('JSString', () {
    final Pointer<Utf8> cstring = '123'.toNativeUtf8();
    final JSStringRef string = JSStringCreateWithUTF8CString(cstring);
    malloc.free(cstring);
    void check() {
      final Pointer<JSChar> characters = JSStringGetCharactersPtr(string);
      final int charactersLength = JSStringGetLength(string);
      expect(String.fromCharCodes(Uint16List.view(characters.cast<Uint16>().asTypedList(charactersLength).buffer, 0, charactersLength)), '123');
    }

    check();
    check();
    JSStringRelease(string);
  });
}
