import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

import '../json/json_array.dart';
import 'model/book_source.dart';

void main() {
  setUp(() {});

  tearDown(() {});

  test('阅读 3.0', () {
    final List<BookSource> sources = JsonArrayUtils.fromJsonArray(
      json.decode(File(path.join(Directory.current.path, 'test/misc/legado/all.json')).readAsStringSync()) as List<dynamic>,
      (Object json) => BookSource.fromJson(json as Map<String, dynamic>),
    );
    if (kDebugMode) {
      print('sources: ${sources.length}');
    }
  });
}
