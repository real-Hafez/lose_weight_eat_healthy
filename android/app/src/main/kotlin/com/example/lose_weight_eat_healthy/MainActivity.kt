package com.example.lose_weight_eat_healthy

import android.appwidget.AppWidgetManager
import android.app.PendingIntent
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.widget.RemoteViews
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.lose_weight_eat_healthy.HomeScreenWidget
import android.content.BroadcastReceiver

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.fuckin/widget"
    private lateinit var dataUpdateReceiver: BroadcastReceiver

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "addWidgetToHomeScreen" -> {
                        val added = addWidgetToHomeScreen()
                        result.success(added)
                    }
                    "updateWidget" -> {
                        val args = call.arguments as? Map<String, Any> ?: throw IllegalArgumentException("Invalid arguments")
                        val waterDrunk = args["water"] as? Int ?: throw IllegalArgumentException("Invalid water value")
                        val unit = args["unit"] as? String ?: throw IllegalArgumentException("Invalid unit")
                        updateHomeScreenWidget(waterDrunk, unit)
                        result.success(null)
                    }
                    "getWidgetCounter" -> {
                        val waterDrunk = getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
                            .getInt("water_drunk", 0)
                        result.success(waterDrunk)
                    }
                    "updateWidgetUnit" -> {
                        val unit = call.arguments as? String ?: throw IllegalArgumentException("Invalid unit")
                        updateWidgetUnit(unit)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("ERROR", "An error occurred: ${e.message}", null)
            }
        }

        dataUpdateReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (intent.action == "com.example.fuckin.WIDGET_UPDATED") {
                    val waterDrunk = intent.getIntExtra("water_drunk", 0)
                    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                        .invokeMethod("updateAppState", waterDrunk)
                }
            }
        }
        registerReceiver(dataUpdateReceiver, IntentFilter("com.example.fuckin.WIDGET_UPDATED"))
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(dataUpdateReceiver)
    }

    private fun updateHomeScreenWidget(waterDrunk: Int, unit: String) {
        val prefs = getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
        prefs.edit()
            .putInt("water_drunk", waterDrunk)
            .putString("selected_unit", unit)
            .apply()

        val appWidgetManager = AppWidgetManager.getInstance(this)
        val widgetComponent = ComponentName(this, HomeScreenWidget::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(widgetComponent)

        val updateIntent = Intent(this, HomeScreenWidget::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
        }
        sendBroadcast(updateIntent)
    }

    private fun updateWidgetUnit(unit: String) {
        val prefs = getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
        prefs.edit()
            .putString("selected_unit", unit)
            .apply()

        val appWidgetManager = AppWidgetManager.getInstance(this)
        val widgetComponent = ComponentName(this, HomeScreenWidget::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(widgetComponent)

        val updateIntent = Intent(this, HomeScreenWidget::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
        }
        sendBroadcast(updateIntent)
    }

    private fun addWidgetToHomeScreen(): Boolean {
        val appWidgetManager = AppWidgetManager.getInstance(this)
        val myProvider = ComponentName(this, HomeScreenWidget::class.java)

        if (appWidgetManager.isRequestPinAppWidgetSupported) {
            // Create the PendingIntent to launch the configuration activity when the widget is added
            val intent = Intent(this, MainActivity::class.java)
            val successCallback = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)

            appWidgetManager.requestPinAppWidget(myProvider, null, successCallback)
            return true
        }
        return false
    }
}
