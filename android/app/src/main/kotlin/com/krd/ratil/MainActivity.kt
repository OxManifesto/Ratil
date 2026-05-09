package com.krd.ratil

import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.krd.ratil/device"

    override fun getBackgroundMode(): BackgroundMode {
        return BackgroundMode.opaque
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getManufacturer") {
                result.success(Build.MANUFACTURER)
            } else if (call.method == "openBatterySettings") {
                try {
                    val intent = android.content.Intent(android.provider.Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                    startActivity(intent)
                    result.success(true)
                } catch (e: Exception) {
                    try {
                         val intent = android.content.Intent(android.provider.Settings.ACTION_SETTINGS)
                         startActivity(intent)
                         result.success(true)
                    } catch (e2: Exception) {
                         result.error("UNAVAILABLE", "Could not open settings", null)
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
