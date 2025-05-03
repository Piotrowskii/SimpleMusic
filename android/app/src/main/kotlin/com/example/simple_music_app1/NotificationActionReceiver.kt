package com.example.simple_music_app1

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.MethodChannel

object NotificationBridge {
    var channel: MethodChannel? = null
}

class NotificationActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            "ACTION_PREVIOUS" -> {
                NotificationBridge.channel?.invokeMethod("previous", null)
            }
            "ACTION_PLAY" -> {
                NotificationBridge.channel?.invokeMethod("play", null)
            }
            "ACTION_PAUSE" -> {
                NotificationBridge.channel?.invokeMethod("pause", null)
            }
            "ACTION_NEXT" -> {
                NotificationBridge.channel?.invokeMethod("next", null)
            }
        }
    }
}