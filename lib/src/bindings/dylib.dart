import 'dart:ffi';

import 'dart:io';

final DynamicLibrary jscLib = () {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('libjsc.so');
  } else if (Platform.isIOS || Platform.isMacOS) {
    return DynamicLibrary.open('JavaScriptCore.framework/JavaScriptCore');
  }
  throw UnsupportedError('platform(${Platform.operatingSystem}) not supported');
}();
