package com.visa.eva

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import android.net.Uri
import java.io.File
import java.io.BufferedReader
import java.io.InputStreamReader
import android.os.Build
import android.provider.Settings

class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "launchUrl"
    private val SECURITY_CHANNEL = "device_security_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "launchUrl")
            .setMethodCallHandler { call, result ->
                if (call.method == "openUrl") {
                    val url = call.arguments as String
                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                    startActivity(intent)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }

        // Device Security Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SECURITY_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isDeviceCompromised" -> {
                        result.success(isDeviceRooted())
                    }

                    "isDeveloperModeEnabled" -> {
                        result.success(isDeveloperModeEnabled())
                    }

                    "performSecurityCheck" -> {
                        val isCompromised = isDeviceRooted()
                        val isDeveloperMode = isDeveloperModeEnabled()
                        val securityResult = mapOf(
                            "isCompromised" to isCompromised,
                            "isDeveloperMode" to isDeveloperMode,
                            "isSecure" to (!isCompromised && !isDeveloperMode),
                            "platform" to "android"
                        )
                        result.success(securityResult)
                    }

                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    /**
     * Checks if the device is rooted
     * @return true if device is rooted, false otherwise
     */
    private fun isDeviceRooted(): Boolean {
        // Check for common root indicators
        val rootIndicators = arrayOf(
            "/system/app/Superuser.apk",
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/su",
            "/su/bin/su"
        )

        // Check if any root indicator exists
        for (path in rootIndicators) {
            if (File(path).exists()) {
                return true
            }
        }

        // Check for build tags that indicate root
        val buildTags = Build.TAGS
        if (buildTags != null && buildTags.contains("test-keys")) {
            return true
        }

        // Check if su command is available (most reliable method)
        return isCommandAvailable("su")
    }

    /**
     * Checks if developer mode is enabled
     * @return true if developer mode is enabled, false otherwise
     */
    private fun isDeveloperModeEnabled(): Boolean {
        return try {
            Settings.Global.getInt(contentResolver, Settings.Global.ADB_ENABLED, 0) == 1
        } catch (e: Exception) {
            false
        }
    }

    /**
     * Checks if a command is available in the system
     * @param command The command to check
     * @return true if command is available, false otherwise
     */
    private fun isCommandAvailable(command: String): Boolean {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("which", command))
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            val line = reader.readLine()
            reader.close()
            process.waitFor()
            line != null
        } catch (e: Exception) {
            false
        }
    }
}
