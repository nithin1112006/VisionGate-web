package com.example.faculty_sphere

import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import java.text.SimpleDateFormat
import java.util.*

/**
 * WorkManager worker that relaunches AttendanceForegroundService.
 *
 * Triggered from AttendanceForegroundService.onTaskRemoved() to ensure the service
 * restarts within a few seconds after the user swipes the app from recents.
 *
 * WorkManager respects Doze windows and battery constraints better than
 * AlarmManager.set() on Android 12+.
 */
class ServiceRestartWorker(
    private val context: Context,
    params: WorkerParameters
) : CoroutineWorker(context, params) {

    companion object {
        private const val TAG = "ServiceRestartWorker"
        const val WORK_NAME = "restart_attendance_service"
    }

    override suspend fun doWork(): Result {
        val prefs = context.getSharedPreferences("AttendanceNativePrefs", Context.MODE_PRIVATE)
        val token = prefs.getString("token", "") ?: ""
        if (token.isEmpty()) {
            Log.d(TAG, "No saved token — not restarting service.")
            return Result.success()
        }

        val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        sdf.timeZone = TimeZone.getTimeZone("GMT+5:30")
        val today = sdf.format(Date())
        prefs.edit().putString("startDay", today).apply()

        Log.d(TAG, "Restarting AttendanceForegroundService via WorkManager for day=$today.")
        val baseUrl = prefs.getString("baseUrl", "https://app.srishakthicgpa.in") ?: "https://app.srishakthicgpa.in"
        val regNo = prefs.getString("regNo", "") ?: ""
        val deviceSessionId = prefs.getString("deviceSessionId", "") ?: ""
        val geofenceLat = prefs.getFloat("geofenceLat", 11.0396f).toDouble()
        val geofenceLng = prefs.getFloat("geofenceLng", 77.0747f).toDouble()
        val geofenceRadius = prefs.getFloat("geofenceRadius", 250f)

        val intent = Intent(context, AttendanceForegroundService::class.java).apply {
            action = AttendanceForegroundService.ACTION_START
            putExtra(AttendanceForegroundService.EXTRA_BASE_URL, baseUrl)
            putExtra(AttendanceForegroundService.EXTRA_TOKEN, token)
            putExtra(AttendanceForegroundService.EXTRA_REG_NO, regNo)
            putExtra(AttendanceForegroundService.EXTRA_DEVICE_SESSION_ID, deviceSessionId)
            putExtra(AttendanceForegroundService.EXTRA_GEOFENCE_LAT, geofenceLat)
            putExtra(AttendanceForegroundService.EXTRA_GEOFENCE_LNG, geofenceLng)
            putExtra(AttendanceForegroundService.EXTRA_GEOFENCE_RADIUS, geofenceRadius)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent)
        } else {
            context.startService(intent)
        }
        return Result.success()
    }
}
