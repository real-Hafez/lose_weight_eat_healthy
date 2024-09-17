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
import android.content.BroadcastReceiver
import android.app.AlarmManager
import java.util.Calendar
import java.text.SimpleDateFormat
import java.util.Locale

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.lose_weight_eat_healthy/widget"
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
                        val waterNeeded = args["water"] as? Double ?: throw IllegalArgumentException("Invalid water value")
                        val unit = args["unit"] as? String ?: throw IllegalArgumentException("Invalid unit")
                        val waterDrunk = args["water_drunk"] as? Double ?: throw IllegalArgumentException("Invalid water_drunk value")
                        val wakeUpTime = args["wake_up_time"] as? String
                        updateHomeScreenWidget(waterNeeded, waterDrunk, unit)
                        if (wakeUpTime != null) {
                            scheduleWidgetReset(wakeUpTime)
                        }
                        result.success(null)
                    }
                    "getWidgetCounter" -> {
                        val waterDrunk = getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
                            .getFloat("water_drunk", 0f)
                        result.success(waterDrunk)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("ERROR", "An error occurred: ${e.message}", null)
            }
        }

        dataUpdateReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (intent.action == "com.example.lose_weight_eat_healthy.WIDGET_UPDATED") {
                    val waterDrunk = intent.getFloatExtra("water_drunk", 0f)
                    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                        .invokeMethod("updateAppState", waterDrunk)
                }
            }
        }
        registerReceiver(dataUpdateReceiver, IntentFilter("com.example.lose_weight_eat_healthy.WIDGET_UPDATED"))
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(dataUpdateReceiver)
    }

    private fun updateHomeScreenWidget(waterNeeded: Double, waterDrunk: Double, unit: String) {
        val prefs = getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
        prefs.edit()
            .putFloat("water_needed", waterNeeded.toFloat())
            .putFloat("water_drunk", waterDrunk.toFloat())
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
            val remoteViews = RemoteViews(packageName, R.layout.home_screen_widget)
            
            val prefs = getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
            val waterDrunk = prefs.getFloat("water_drunk", 0f)
            val waterNeeded = prefs.getFloat("water_needed", 2500f)
            val unit = prefs.getString("selected_unit", "mL") ?: "mL"
            val percentage = ((waterDrunk / waterNeeded) * 100).toInt().coerceIn(0, 100)

            remoteViews.setTextViewText(R.id.widget_title, "Water Tracker")
            remoteViews.setTextViewText(R.id.appwidget_text, "%.1f %s / %.1f %s".format(waterDrunk, unit, waterNeeded, unit))
            remoteViews.setTextViewText(R.id.water_percentage, "$percentage%")
            remoteViews.setProgressBar(R.id.water_progress, 100, percentage, false)

            val configIntent = Intent(this, MainActivity::class.java)
            val configPendingIntent = PendingIntent.getActivity(
                this,
                0,
                configIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

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
        val sdf = SimpleDateFormat("h:mm a", Locale.US)
        val date = sdf.parse(wakeUpTime)
        date?.let {
            calendar.time = it
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
}

