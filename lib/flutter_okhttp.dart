import 'dart:typed_data';

import 'package:http/http.dart';

import 'flutter_okhttp_platform_interface.dart';

class FlutterOkhttp {
  Future<String?> getPlatformVersion() {
    return FlutterOkhttpPlatform.instance.getPlatformVersion();
  }
}

class OkHttpClient extends BaseClient {
  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    var bytes = await request.finalize().toBytes();
    var resp = {
      'url': request.url.toString(),
      'headers': request.headers,
      'method': request.method,
      'body': bytes.isNotEmpty ? bytes : null,
    };

    var res = await FlutterOkhttpPlatform.instance.sendRequest(resp);

    Uint8List bodyRec = res['body'];

    return StreamedResponse(
      ByteStream.fromBytes(bodyRec),
      res['statusCode'],
      contentLength: bodyRec.length,
      request: request,
      headers: (res['headers'] as Map).cast(),
      reasonPhrase: res['reasonPhrase'],
    );
  }
}
