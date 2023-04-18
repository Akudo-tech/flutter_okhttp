package com.example.flutter_okhttp

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterOkhttpPlugin */
class FlutterOkhttpPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var client: FlutterOkHttpClient

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    client = FlutterOkHttpClient(flutterPluginBinding.applicationContext, 1024*1024*50)
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_okhttp")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "sendRequest") {
      val url = call.argument<String>("url")?: run {
        result.error("NULL-VALUE", "url cant be null", "url is null")
        return
      }
      val headers = call.argument<Map<String,String>>("headers")?: run {
        result.error("NULL-VALUE", "headers cant be null", "headers is null")
        return
      }
      val method = call.argument<String>("method")?: run {
        result.error("NULL-VALUE", "method cant be null", "method is null")
        return
      }
      val body = call.argument<ByteArray>("body")
      client.makeRequest(url,method,body,headers,result)

    }else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
