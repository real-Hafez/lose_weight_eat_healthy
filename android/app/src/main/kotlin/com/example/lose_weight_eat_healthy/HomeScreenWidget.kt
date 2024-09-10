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

        if (action == "com.example.lose_weight_eat_healthy.INCREMENT" || action == "com.example.lose_weight_eat_healthy.DECREMENT") {
            val widgetClickIntent = Intent(context, WidgetClickReceiver::class.java).apply {
                this.action = action
            }
            context.sendBroadcast(widgetClickIntent)
        }
    }

    companion object {
        private const val TOTAL_CUPS = 10
        private const val LITERS_PER_CUP = 0.3

        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val prefs = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
            val cupsDrunk = prefs.getInt("cups_drunk", 0)
            val litersDrunk = cupsDrunk * LITERS_PER_CUP
            val totalLiters = TOTAL_CUPS * LITERS_PER_CUP
            val percentage = ((litersDrunk / totalLiters) * 100).toInt().coerceIn(0, 100)

            val widgetText = String.format("%.1f L / %.1f L", litersDrunk, totalLiters)
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