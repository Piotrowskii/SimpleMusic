package com.example.simple_music_app1

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.support.v4.media.session.MediaSessionCompat
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(){
    private val CHANNEL = "com.example.notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.notifications")
        NotificationBridge.channel = channel

        channel.setMethodCallHandler { call, result ->
            if (call.method == "showNotification") {
                val title = call.argument<String>("title") ?: "Unknown Title"
                val artist = call.argument<String>("artist") ?: "Unknown Artist"
                val isPlaying = call.argument<Boolean>("isPlaying") ?: false
                val color = call.argument<String>("color") ?: "#3957cf"
                showNotification(title, artist,isPlaying,color)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun showNotification(title: String, artist: String, isPlaying: Boolean, color: String) {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = "default_channel_id"
        val channelName = "Default Channel"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_DEFAULT)
            notificationManager.createNotificationChannel(channel)
            channel.setSound(null, null)
            channel.enableVibration(false)
            channel.lockscreenVisibility = Notification.VISIBILITY_PUBLIC
        }

        val previousIntent = Intent(this, NotificationActionReceiver::class.java).apply {
            action = "ACTION_PREVIOUS"
        }
        val playIntent = Intent(this, NotificationActionReceiver::class.java).apply {
            action = "ACTION_PLAY"
        }
        val pauseIntent = Intent(this, NotificationActionReceiver::class.java).apply {
            action = "ACTION_PAUSE"
        }
        val nextIntent = Intent(this, NotificationActionReceiver::class.java).apply {
            action = "ACTION_NEXT"
        }

        val previousPendingIntent = PendingIntent.getBroadcast(this, 0, previousIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val playPendingIntent = PendingIntent.getBroadcast(this, 1, playIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val pausePendingIntent = PendingIntent.getBroadcast(this, 1, pauseIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val nextPendingIntent = PendingIntent.getBroadcast(this, 2, nextIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)

        val playPauseIcon = if (isPlaying) android.R.drawable.ic_media_pause else android.R.drawable.ic_media_play
        val correctIntent = if (isPlaying) pausePendingIntent else playPendingIntent

        val mediaSession = MediaSessionCompat(this, "MediaSessionTag")

        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle(title)
            .setContentText(artist)
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setColor(Color.parseColor(color))
            .setOngoing(true)
            .setColorized(true)
            .setOnlyAlertOnce(true)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC) // show on lockscreen
            .addAction(android.R.drawable.ic_media_previous, "Poprzednia", previousPendingIntent)
            .addAction(playPauseIcon, "Start/Stop", correctIntent)
            .addAction(android.R.drawable.ic_media_next, "Następna", nextPendingIntent)
            .setStyle(
                androidx.media.app.NotificationCompat.MediaStyle()
                    .setShowActionsInCompactView(0, 1, 2)
                    .setMediaSession(mediaSession.sessionToken) // 👈 Required
            )
            .setPriority(NotificationCompat.PRIORITY_LOW) // LOW or DEFAULT is okay for ongoing
            .build()

        notificationManager.notify(0, notification)
    }
}
