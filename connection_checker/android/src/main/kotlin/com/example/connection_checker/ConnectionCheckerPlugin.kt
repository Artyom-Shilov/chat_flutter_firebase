package com.example.connection_checker

import ConnectionChecker
import ConnectionCheckerImpl
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ConnectionCheckerPlugin */
class ConnectionCheckerPlugin: FlutterPlugin {

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    ConnectionChecker.setUp(
      flutterPluginBinding.binaryMessenger,
      ConnectionCheckerImpl(context = flutterPluginBinding.applicationContext))
  }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
  }
}
