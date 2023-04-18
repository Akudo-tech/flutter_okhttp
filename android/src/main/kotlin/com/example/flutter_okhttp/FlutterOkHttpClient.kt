package com.example.flutter_okhttp

import android.content.Context
import android.util.Log
import okhttp3.*
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.IOException
import java.net.UnknownHostException


class FlutterOkHttpClient(val context:Context, val cacheSize:Long ) {

    /** Dangerous interceptor that rewrites the server's cache-control header.  */
    private val REWRITE_CACHE_CONTROL_INTERCEPTOR = Interceptor { chain ->

        val originalResponse = chain.proceed(chain.request())

        originalResponse.newBuilder()
                .header("Cache-Control", "no-cache")
                .build()
    }

    private val client = OkHttpClient.Builder().cache(
            Cache(context.cacheDir, cacheSize))
            .addNetworkInterceptor(
                   REWRITE_CACHE_CONTROL_INTERCEPTOR
            )
            .eventListener(object : EventListener() {
                override fun cacheHit(call: Call, response: Response) {
//                    Log.d("flutterokhttp/cache","cache pass")

                    super.cacheHit(call, response)
                }

                override fun cacheMiss(call: Call) {
//                    Log.d("flutterokhttp/cache","cache missed")

                    super.cacheMiss(call)
                }

            })
            .build()


    public fun makeRequest(url: String, method: String, body: ByteArray?,
                           headers: Map<String,String>,
                           result: io.flutter.plugin.common.MethodChannel.Result
    ){

        var request = Request.Builder().method(method, body?.toRequestBody()).url(url)
        for((k,v) in headers){
            request = request.header(k,v)
        }
        var finalreq = request.build()
        client.newCall(finalreq).enqueue(
                object : Callback{
                    override fun onFailure(call: Call, e: IOException) {
                        if(e is UnknownHostException){
                            result.error("IO-NETWORK","Message: ${e.message}\nCause: ${e.cause}", "Message: ${e.message}\nCause: ${e.cause}\nTrace: ${e.stackTrace}" )
                        }else {
                            result.error("IO-ERROR", "Message: ${e.message}\nCause: ${e.cause}", "Message: ${e.message}\nCause: ${e.cause}\nTrace: ${e.stackTrace}")
                        }                    }

                    override fun onResponse(call: Call, response: Response) {
                        var body = response.body?.bytes()
                        result.success(
                                mapOf(
                                        "statusCode" to response.code,
                                        "body" to body,
                                        "headers" to response.headers.toMap(),
                                        "reasonPhrase" to response.message
                                )
                        )
                    }

                }
        )
    }
}