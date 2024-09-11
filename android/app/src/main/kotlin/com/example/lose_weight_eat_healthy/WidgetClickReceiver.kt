package com.example.lose_weight_eat_healthy

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class WidgetClickReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val widgetComponent = ComponentName(context, HomeScreenWidget::class.java)

        when (action) {
            "com.example.lose_weight_eat_healthy.INCREMENT" -> {
                incrementWaterDrunk(context)
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
        val waterDrunk = prefs.getFloat("water_drunk", 0f)
        val waterNeeded = prefs.getFloat("water_needed", 2500f)
        val selectedUnit = prefs.getString("selected_unit", "mL") ?: "mL"

        val incrementAmount = when (selectedUnit) {
            "L" -> 0.3f
            "mL" -> 300f
            "US oz" -> 10f
            else -> 300f
        }

        val newWaterDrunk = (waterDrunk + incrementAmount).coerceAtMost(waterNeeded)
        prefs.edit().putFloat("water_drunk", newWaterDrunk).apply()

        // Notify the app about the update
        val updateIntent = Intent("com.example.fuckin.WIDGET_UPDATED")
        updateIntent.putExtra("water_drunk", newWaterDrunk)
        context.sendBroadcast(updateIntent)
    }
}