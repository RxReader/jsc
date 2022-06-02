import 'dart:io';

import 'package:jsc/src/misc/tinker.dart';

class Jsc {
  const Jsc._();

  static void init() {
    if (Platform.isAndroid) {
      Tinker.applyWorkaroundOnOldAndroidVersions();
    }
  }
}
