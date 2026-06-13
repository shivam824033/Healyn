package com.healyn.healyn

import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "deviceLabel" -> result.success(deviceLabel())
                    else -> result.notImplemented()
                }
            }
    }

    /// A human-readable name for this device for the "Signed-in devices" list,
    /// e.g. "Samsung SM-S921B". MODEL often already carries the brand, so avoid
    /// doubling it up ("Samsung Samsung ...").
    private fun deviceLabel(): String {
        val manufacturer = (Build.MANUFACTURER ?: "").trim()
        val model = (Build.MODEL ?: "").trim()
        val label = when {
            model.isEmpty() -> manufacturer
            manufacturer.isEmpty() -> model
            model.startsWith(manufacturer, ignoreCase = true) -> model
            else -> "${manufacturer.replaceFirstChar { it.uppercase() }} $model"
        }
        return label.ifBlank { "Android device" }
    }

    companion object {
        private const val CHANNEL = "healyn/device_info"
    }
}
