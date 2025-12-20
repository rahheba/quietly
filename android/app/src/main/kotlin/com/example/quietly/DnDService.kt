package com.example.quietly

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class DnDService : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private val notificationManager: NotificationManager by lazy {
        context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    }

    companion object {
        private const val CHANNEL = "app.dnd.control"
        
        @JvmStatic
        fun registerWith(flutterEngine: FlutterEngine) {
            val plugin = DnDService()
            flutterEngine.plugins.add(plugin)
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "hasDndAccess" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    result.success(notificationManager.isNotificationPolicyAccessGranted)
                } else {
                    // For versions below M, DnD access is not required
                    result.success(true)
                }
            }
            "openSettings" -> {
                openDnDSettings()
                result.success(null)
            }
            "setSilent" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    if (!notificationManager.isNotificationPolicyAccessGranted) {
                        result.error("PERMISSION_DENIED", "DnD access not granted", null)
                        return
                    }
                    notificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_NONE)
                    result.success(true)
                } else {
                    // For versions below M, try to set ringer mode to silent
                    val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                    audioManager.ringerMode = AudioManager.RINGER_MODE_SILENT
                    result.success(true)
                }
            }
            "restore" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    if (notificationManager.isNotificationPolicyAccessGranted) {
                        notificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL)
                    }
                }
                // Always try to restore ringer mode to normal
                val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                audioManager.ringerMode = AudioManager.RINGER_MODE_NORMAL
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    private fun openDnDSettings() {
        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
        } else {
            Intent(Settings.ACTION_SOUND_SETTINGS)
        }
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }
}