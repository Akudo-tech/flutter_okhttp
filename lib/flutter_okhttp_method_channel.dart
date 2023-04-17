import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_okhttp_platform_interface.dart';

/// An implementation of [FlutterOkhttpPlatform] that uses method channels.
class MethodChannelFlutterOkhttp extends FlutterOkhttpPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_okhttp');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future sendRequest(data) async {
    final response = await methodChannel.invokeMethod('sendRequest', data);
    return response;
  }
}
