package com.example.lose_weight_eat_healthy

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class HomeScreenWidget : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        private const val TOTAL_WATER_LITERS = 2.5 // Example total water needed

        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val prefs = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
            val cupsDrunk = prefs.getInt("cups_drunk", 0)
            val selectedUnit = prefs.getString("selected_unit", "L") ?: "L"

            // Convert cupsDrunk to liters or other unit
            val litersDrunk = when (selectedUnit) {
                "L" -> cupsDrunk * 0.3
                "mL" -> cupsDrunk * 300.0
                "US oz" -> cupsDrunk * 10.0
                else -> cupsDrunk * 0.3
            }

            val totalLiters = TOTAL_WATER_LITERS
            val percentage = ((litersDrunk / totalLiters) * 100).toInt().coerceIn(0, 100)

            val widgetText = String.format("%.1f %s / %.1f %s", litersDrunk, selectedUnit, totalLiters, selectedUnit)
            val views = RemoteViews(context.packageName, R.layout.home_screen_widget)
            views.setTextViewText(R.id.appwidget_text, widgetText)
            views.setTextViewText(R.id.water_percentage, "$percentage%")
            views.setProgressBar(R.id.water_progress, 100, percentage, false)

            // Setup intents
            val openAppIntent = Intent(context, MainActivity::class.java)
            val openAppPendingIntent = PendingIntent.getActivity(context, 0, openAppIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.widget_layout, openAppPendingIntent)

            val incrementIntent = Intent(context, WidgetClickReceiver::class.java).apply {
                action = "com.example.lose_weight_eat_healthy.INCREMENT"
            }
            val incrementPendingIntent = PendingIntent.getBroadcast(context, 0, incrementIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.btn_increment, incrementPendingIntent)

            // Remove decrement button handling

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
