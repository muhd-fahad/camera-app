package com.example.camera_app

import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // Defines the channel name shared with Flutter
    private val CHANNEL_NAME = "com.example/capture"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Sets up the MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            .setMethodCallHandler { call, result ->

                // Check which method was called by the Flutter side
                when (call.method) {
                    "captureMessage" -> { // Updated method name
                        // Success! Send the desired message back to Flutter.
                        result.success("Photo captured")
                    }
                    else -> {
                        // Flutter called a method we don't know about
                        result.notImplemented()
                    }
                }
            }
    }
}