package com.example.taskreminder.task_reminder
import android.os.Build
import android.icu.util.TimeZone
import java.util.TimeZone as LegacyTimeZone
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity(){
    private val CHANNEL = "timezone_helper"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getTimeZoneName") {
                result.success(getFullTimeZoneName())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getFullTimeZoneName(): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            TimeZone.getDefault().id
        } else {
            LegacyTimeZone.getDefault().id
        }
    }
}
