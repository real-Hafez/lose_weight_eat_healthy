package com.example.lose_weight_eat_healthy

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class WidgetClickReceiver : BroadcastReceiver() {
    private val TOTAL_CUPS = 10 // Total cups (internal representation)
    private val LITERS_PER_CUP = 0.3 // Convert cups to liters

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val widgetComponent = ComponentName(context, HomeScreenWidget::class.java)
        var cupsDrunk = getCounterFromPreferences(context)

        // Handle button actions (increment)
        when (action) {
            "com.example.lose_weight_eat_healthy.INCREMENT" -> {
                if (cupsDrunk < TOTAL_CUPS) cupsDrunk++
            }
        }

        // Calculate new values
        val litersDrunk = cupsDrunk * LITERS_PER_CUP
        val percentage = (litersDrunk / (TOTAL_CUPS * LITERS_PER_CUP) * 100).toInt()

        // Update the widget UI
        val remoteViews = RemoteViews(context.packageName, R.layout.home_screen_widget)
        remoteViews.setTextViewText(R.id.appwidget_text, "%.1f L / %.1f L".format(litersDrunk, TOTAL_CUPS * LITERS_PER_CUP))
        remoteViews.setTextViewText(R.id.water_percentage, "$percentage%")
        remoteViews.setProgressBar(R.id.water_progress, 100, percentage, false)

        // Immediate widget refresh
        appWidgetManager.updateAppWidget(widgetComponent, remoteViews)

        // Save the updated state (cups drunk)
        saveCounterToPreferences(context, cupsDrunk)
    }

    private fun getCounterFromPreferences(context: Context): Int {
        val sharedPreferences = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
        return sharedPreferences.getInt("cups_drunk", 0)
    }

    private fun saveCounterToPreferences(context: Context, cupsDrunk: Int) {
        val sharedPreferences = context.getSharedPreferences("widget_prefs", Context.MODE_PRIVATE)
        sharedPreferences.edit().putInt("cups_drunk", cupsDrunk).apply()
    }
}
