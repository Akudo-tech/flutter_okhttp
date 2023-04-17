import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_okhttp_method_channel.dart';

abstract class FlutterOkhttpPlatform extends PlatformInterface {
  /// Constructs a FlutterOkhttpPlatform.
  FlutterOkhttpPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterOkhttpPlatform _instance = MethodChannelFlutterOkhttp();

  /// The default instance of [FlutterOkhttpPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterOkhttp].
  static FlutterOkhttpPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterOkhttpPlatform] when
  /// they register themselves.
  static set instance(FlutterOkhttpPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future sendRequest(data) async {
    throw UnimplementedError('sendRequest() has not been implemented.');
  }
}
