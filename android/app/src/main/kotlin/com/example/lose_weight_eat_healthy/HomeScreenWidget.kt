package com.example.lose_weight_eat_healthy

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import com.example.lose_weight_eat_healthy.MainActivity

class HomeScreenWidget : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        val action = intent.action

        if (action == "com.example.lose_weight_eat_healthy.INCREMENT") {
            val prefs = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
            val waterDrunk = prefs.getInt("water_drunk", 0) + 300 // Increment by 300 mL

            prefs.edit().putInt("water_drunk", waterDrunk).apply()

            val appWidgetManager = AppWidgetManager.getInstance(context)
            val widgetComponent = ComponentName(context, HomeScreenWidget::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(widgetComponent)

            onUpdate(context, appWidgetManager, appWidgetIds)

            val appIntent = Intent("com.example.lose_weight_eat_healthy.WIDGET_UPDATED").apply {
                putExtra("water_drunk", waterDrunk)
            }
            context.sendBroadcast(appIntent)
        }
    }

    companion object {
        private const val TOTAL_MILLILITERS = 3000.0

        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val prefs = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
            val waterDrunk = prefs.getInt("water_drunk", 0)
            val selectedUnit = prefs.getString("selected_unit", "mL") ?: "mL"
            val unitConversion = when (selectedUnit) {
                "L" -> 1000.0
                "US oz" -> 29.5735
                else -> 1.0 // mL
            }

            val convertedWaterDrunk = waterDrunk / unitConversion
            val convertedTotal = TOTAL_MILLILITERS / unitConversion
            val percentage = ((waterDrunk / TOTAL_MILLILITERS) * 100).toInt().coerceIn(0, 100)

            val widgetText = String.format("%.1f %s / %.1f %s", convertedWaterDrunk, selectedUnit, convertedTotal, selectedUnit)
            val views = RemoteViews(context.packageName, R.layout.home_screen_widget)
            views.setTextViewText(R.id.appwidget_text, widgetText)
            views.setTextViewText(R.id.water_percentage, "$percentage%")
            views.setProgressBar(R.id.water_progress, 100, percentage, false)

            // Intent to open the app
            val openAppIntent = Intent(context, MainActivity::class.java)
            val openAppPendingIntent = PendingIntent.getActivity(
                context, 
                0, 
                openAppIntent, 
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_layout, openAppPendingIntent)

            // Intent for increment action
            val incrementIntent = Intent(context, HomeScreenWidget::class.java).apply {
                action = "com.example.lose_weight_eat_healthy.INCREMENT"
            }
            val incrementPendingIntent = PendingIntent.getBroadcast(
                context, 
                0, 
                incrementIntent, 
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.btn_increment, incrementPendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
