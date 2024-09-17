package com.example.lose_weight_eat_healthy

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import io.flutter.plugin.common.MethodChannel

class WidgetClickReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val widgetComponent = ComponentName(context, HomeScreenWidget::class.java)

        when (action) {
            "com.example.lose_weight_eat_healthy.INCREMENT" -> {
                incrementWaterDrunk(context)
                notifyFlutterApp(context)
            }
        }

        // Update the widget
        val appWidgetIds = appWidgetManager.getAppWidgetIds(widgetComponent)
        for (appWidgetId in appWidgetIds) {
            HomeScreenWidget.updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun incrementWaterDrunk(context: Context) {
        val prefs = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
        val waterDrunk = prefs.getFloat("water_drunk", 0f) + 250f  // Increment by 250 mL (example)
        prefs.edit().putFloat("water_drunk", waterDrunk).apply()
    }

    private fun notifyFlutterApp(context: Context) {
        // Notify Flutter app using a broadcast intent
        val intent = Intent("com.example.lose_weight_eat_healthy.WIDGET_UPDATED")
        intent.putExtra("water_drunk", getWaterDrunk(context))
        context.sendBroadcast(intent)
    }

    private fun getWaterDrunk(context: Context): Float {
        val prefs = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
        return prefs.getFloat("water_drunk", 0f)
    }
}
