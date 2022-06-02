import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jsc/src/core/js_context.dart';
import 'package:jsc/src/core/js_value.dart';
import 'package:jsc/src/vm/js_vm.dart';

void main() {
  assert(Platform.isMacOS);

  test('JSVm.throw', () {
    final JSVm vm = JSVm.jsc();
    vm.evaluate('throw "An error."');
    vm.dispose();
  });

  test('JSVm.json', () {
    final JSVm vm = JSVm.jsc();
    final JSValue value = vm.evaluate(File('test/json/json-generator-dot-com-128-rows.json').readAsStringSync());
    if (kDebugMode) {
      print(value.createJSONString());
    }
    vm.dispose();
  });

  test('JSVm console.log', () {
    final JSVm vm = JSVm.jsc();
    vm.evaluate('console.log(1, 2, 3)');
    vm.dispose();
  });

  test('JSVm.setTimeout', () async {
    final JSVm vm = JSVm.jsc();
    vm.evaluate('setTimeout(function() {console.warn(">> Hello World")}, 1000)');
    await Future<void>.delayed(Duration(milliseconds: 1000 + 500));
    vm.dispose();
  });

  test('JSVm.setTimeout with params', () async {
    final JSVm vm = JSVm.jsc();
    vm.evaluate('setTimeout(function(text) {console.error(">> Hello " + text)}, 1000, "JSVm")');
    await Future<void>.delayed(Duration(milliseconds: 1000 + 500));
    vm.dispose();
  });

  test('JSVm.setInterval', () async {
    final JSVm vm = JSVm.jsc();
    vm.evaluate('setInterval(function() {console.warn(">> Hello World")}, 1000)');
    await Future<void>.delayed(Duration(milliseconds: 5 * 1000));
    vm.dispose();
  });

  test('JSVm.setInterval with params', () async {
    final JSVm vm = JSVm.jsc();
    vm.evaluate('setInterval(function(text) {console.error(">> Hello " + text)}, 1000, "JSVm")');
    await Future<void>.delayed(Duration(milliseconds: 5 * 1000));
    vm.dispose();
  });

  test('JSVm.registerModuleResolver', () {
    final JSVm vm = JSVm.jsc();
    vm.registerModuleResolver('crypto-js', (JSContext context, List<String> path, String? version) {
      return context.evaluate(File('test/js/crypto-js-3.3.0.js').readAsStringSync());
    });
    vm.evaluate('''
    require("crypto-js");
    var text = 'Hello World!';
    var ciphertext = CryptoJS.AES.encrypt(text, 'secret key 123').toString();
    var bytes  = CryptoJS.AES.decrypt(ciphertext, 'secret key 123');
    var decryptedData = bytes.toString(CryptoJS.enc.Utf8);
    if(decryptedData !== text) throw 'crypto broken!';
    console.log(`>> crypto`);
    ''');
    vm.dispose();
  });
}
