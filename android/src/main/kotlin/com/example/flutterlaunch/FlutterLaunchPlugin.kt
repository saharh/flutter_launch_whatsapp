package com.example.flutterlaunch

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.text.TextUtils
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.net.URLEncoder


class FlutterLaunchPlugin(val mRegistrar: Registrar) : MethodCallHandler {

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "flutter_launch")
            channel.setMethodCallHandler(FlutterLaunchPlugin(registrar))
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        try {
            val context: Context = mRegistrar.activity()
            val pm: PackageManager = context.packageManager

            if (call.method.equals("launchApp")) {

                val app: String? = call.argument("app")
                val phone: String? = call.argument("phone")
                val message: String? = call.argument("message")
                val url = "https://api.whatsapp.com/send?phone=$phone&text=${URLEncoder.encode(message, "UTF-8")}"
                val packageName: String
                if (app == "whatsapp") {
                    packageName = "com.whatsapp"
                } else if (app == "whatsapp_business") {
                    packageName = "com.whatsapp.w4b"
                } else {
                    throw Exception("Unsupported app: $app")
                }
                if (appInstalledOrNot(packageName)) {
                    if (TextUtils.isEmpty(phone)) {
                        openApp(context, packageName)
                        return
                    }
                    val intent = Intent()
                    intent.action = Intent.ACTION_VIEW
                    intent.setPackage(packageName)
                    intent.data = Uri.parse(url)

                    if (intent.resolveActivity(pm) != null) {
                        context.startActivity(intent)
                    }
                }
            }

            if (call.method.equals("hasApp")) {
                val app: String? = call.argument("name");

                when (app) {
                    "facebook" -> result.success(appInstalledOrNot("com.facebook.katana"))
                    "whatsapp" -> result.success(appInstalledOrNot("com.whatsapp"))
                    "whatsapp_business" -> result.success(appInstalledOrNot("com.whatsapp.w4b"))
                    else -> {
                        result.error("App not found", "", null)
                    }
                }
            }
        } catch (e: PackageManager.NameNotFoundException) {
            result.error("Name not found", e.message, null)
        }
    }

    fun openApp(context: Context, packageName: String): Boolean {
        val manager = context.packageManager
        try {
            val i = manager.getLaunchIntentForPackage(packageName)
                    ?: return false
            //throw new ActivityNotFoundException();
            i.addCategory(Intent.CATEGORY_LAUNCHER)
            context.startActivity(i)
            return true
        } catch (e: ActivityNotFoundException) {
            return false
        }

    }

    private fun appInstalledOrNot(uri: String): Boolean {
        val context: Context = mRegistrar.context();
        val pm: PackageManager = context.packageManager
        var appInstalled: Boolean

        try {
            pm.getPackageInfo(uri, PackageManager.GET_ACTIVITIES)
            appInstalled = true
        } catch (e: PackageManager.NameNotFoundException) {
            appInstalled = false
        }

        return appInstalled
    }
}
