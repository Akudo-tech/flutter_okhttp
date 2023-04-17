import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_okhttp/flutter_okhttp_method_channel.dart';

void main() {
  MethodChannelFlutterOkhttp platform = MethodChannelFlutterOkhttp();
  const MethodChannel channel = MethodChannel('flutter_okhttp');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
