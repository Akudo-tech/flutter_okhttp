import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_okhttp/flutter_okhttp.dart';
import 'package:flutter_okhttp/flutter_okhttp_platform_interface.dart';
import 'package:flutter_okhttp/flutter_okhttp_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterOkhttpPlatform
    with MockPlatformInterfaceMixin
    implements FlutterOkhttpPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterOkhttpPlatform initialPlatform = FlutterOkhttpPlatform.instance;

  test('$MethodChannelFlutterOkhttp is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterOkhttp>());
  });

  test('getPlatformVersion', () async {
    FlutterOkhttp flutterOkhttpPlugin = FlutterOkhttp();
    MockFlutterOkhttpPlatform fakePlatform = MockFlutterOkhttpPlatform();
    FlutterOkhttpPlatform.instance = fakePlatform;

    expect(await flutterOkhttpPlugin.getPlatformVersion(), '42');
  });
}
