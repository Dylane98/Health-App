package com.example.higia

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "higia/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasStepCounter" -> {
                    val sm = getSystemService(Context.SENSOR_SERVICE) as SensorManager
                    val sensor: Sensor? = sm.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
                    result.success(sensor != null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
