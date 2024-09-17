package com.example.lose_weight_eat_healthy

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import java.text.SimpleDateFormat
import java.util.*

class HomeScreenWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == "com.example.lose_weight_eat_healthy.RESET_WIDGET") {
            resetWidget(context)
        } else if (intent.action == AppWidgetManager.ACTION_APPWIDGET_UPDATE) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisWidget = ComponentName(context, HomeScreenWidget::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
            onUpdate(context, appWidgetManager, appWidgetIds)
        }
    }

    private fun resetWidget(context: Context) {
        val prefs = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
        prefs.edit().putFloat("water_drunk", 0f).apply()

        val appWidgetManager = AppWidgetManager.getInstance(context)
        val thisWidget = ComponentName(context, HomeScreenWidget::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
        onUpdate(context, appWidgetManager, appWidgetIds)
    }

    companion object {
        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val prefs = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
            val waterDrunk = prefs.getFloat("water_drunk", 0f)
            val waterNeeded = prefs.getFloat("water_needed", 2500f)
            val selectedUnit = prefs.getString("selected_unit", "mL") ?: "mL"

            val widgetText = String.format("%.1f %s / %.1f %s", waterDrunk, selectedUnit, waterNeeded, selectedUnit)
            val percentage = ((waterDrunk / waterNeeded) * 100).toInt().coerceIn(0, 100)

            val views = RemoteViews(context.packageName, R.layout.home_screen_widget)
            views.setTextViewText(R.id.widget_title, "Water Tracker")
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

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

