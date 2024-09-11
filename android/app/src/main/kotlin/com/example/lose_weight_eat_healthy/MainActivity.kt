package com.example.lose_weight_eat_healthy

import android.appwidget.AppWidgetManager
import android.app.PendingIntent
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.widget.RemoteViews
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.lose_weight_eat_healthy.HomeScreenWidget
import android.content.BroadcastReceiver
import android.content.res.ColorStateList
import android.app.AlarmManager
import java.util.Calendar


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
                            .getInt("cups_drunk", 0)
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
            .putInt("cups_drunk", waterDrunk)
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
            // Create a preview of the widget
            val remoteViews = RemoteViews(packageName, R.layout.home_screen_widget)
            
            // Set initial values for the widget preview
            val prefs = getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
            val cupsDrunk = prefs.getInt("cups_drunk", 0)
            val litersDrunk = cupsDrunk * 0.3 // Assuming 1 cup is 0.3 liters
            val totalLiters = 3.0 // Assuming the total goal is 3 liters
            val percentage = ((litersDrunk / totalLiters) * 100).toInt().coerceIn(0, 100)

            remoteViews.setTextViewText(R.id.widget_title, "Water Tracker")
            remoteViews.setTextViewText(R.id.appwidget_text, "%.1f L / %.1f L".format(litersDrunk, totalLiters))
            remoteViews.setTextViewText(R.id.water_percentage, "$percentage%")
            remoteViews.setProgressBar(R.id.water_progress, 100, percentage, false)

            // Create the configuration Activity PendingIntent
            val configIntent = Intent(this, MainActivity::class.java)
            val configPendingIntent = PendingIntent.getActivity(
                this,
                0,
                configIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // Request to pin the widget with the preview
            appWidgetManager.requestPinAppWidget(myProvider, Bundle().apply {
                putParcelable(AppWidgetManager.EXTRA_APPWIDGET_PREVIEW, remoteViews)
            }, configPendingIntent)
            
            return true
        }
        return false
    }
    private fun scheduleWidgetReset(wakeUpTime: String) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, HomeScreenWidget::class.java)
        intent.action = "com.example.lose_weight_eat_healthy.RESET_WIDGET"
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    
        val calendar = Calendar.getInstance()
        val timeParts = wakeUpTime.split(":")
        calendar.set(Calendar.HOUR_OF_DAY, timeParts[0].toInt())
        calendar.set(Calendar.MINUTE, timeParts[1].toInt())
        calendar.set(Calendar.SECOND, 0)
    
        if (calendar.timeInMillis <= System.currentTimeMillis()) {
            calendar.add(Calendar.DAY_OF_YEAR, 1)
        }
    
        alarmManager.setRepeating(
            AlarmManager.RTC_WAKEUP,
            calendar.timeInMillis,
            AlarmManager.INTERVAL_DAY,
            pendingIntent
        )
    }
}
