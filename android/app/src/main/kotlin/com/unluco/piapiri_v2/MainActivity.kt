package com.unluco.piapiri

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.Log
import com.adjust.sdk.Adjust
import com.adjust.sdk.AdjustEvent
import com.adjust.sdk.flutter.AdjustSdk
import com.enqura.enverify.helpers.EnActivityStateTracker
import com.piapiri.unlusdk.AdjustCallback
import com.piapiri.unlusdk.UnluCoLauncherActivity
import com.piapiri.unlusdk.enqualify.data.enums.Environment
import com.useinsider.insider.Insider
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger
        val methodChannel = MethodChannel(binaryMessenger, "PIAPIRI_CHANNEL")

        methodChannel.setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->

            when (call.method) {
                "initEnqura" -> {
                    var enqEnv = Environment.UNLUCO_PROD
                    UnluCoLauncherActivity.start(this, enqEnv) {
                        val intent = Intent(this, MainActivity::class.java)
                        intent.flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
                        this.startActivity(intent)
                    }

                    UnluCoLauncherActivity.onAdjustEvent(object : AdjustCallback {
                        override fun onWelcome() {
                            Log.d("AdjustEvent", "onWelcome")
                            Adjust.trackEvent(AdjustEvent("nlaouo"))
                        }

                        override fun onWhatsWaiting() {
                            Log.d("AdjustEvent", "onWhatsWaiting: ")
                            Adjust.trackEvent(AdjustEvent("lrxjka"))
                        }

                        override fun onFormView() {
                            Log.d("AdjustEvent", "onFormView: ")
                            Adjust.trackEvent(AdjustEvent("9cjj12"))
                        }

                        override fun onOTP() {
                            Log.d("AdjustEvent", "onOTP: ")
                            Adjust.trackEvent(AdjustEvent("l35o1c"))
                        }

                        override fun onIdDetail() {
                            Log.d("AdjustEvent", "onIdDetail: ")
                            Adjust.trackEvent(AdjustEvent("5ttbnz"))
                        }

                        override fun onFaceRecognition() {
                            Log.d("AdjustEvent", "onFaceRecognition: ")
                            Adjust.trackEvent(AdjustEvent("ah7unw"))
                        }

                        override fun onInvestorInfo() {
                            Log.d("AdjustEvent", "onInvestorInfo: ")
                            Adjust.trackEvent(AdjustEvent("5ig883"))
                        }

                        override fun onContractApproval() {
                            Log.d("AdjustEvent", "onContractApproval: ")
                            Adjust.trackEvent(AdjustEvent("sp1gt8"))
                        }

                        override fun onAppointment() {
                            Log.d("AdjustEvent", "onAppointment: ")
                            Adjust.trackEvent(AdjustEvent("ezn0gu"))
                        }

                        override fun onVideoCallInfo() {
                            Log.d("AdjustEvent", "onVideoCallInfo: ")
                            Adjust.trackEvent(AdjustEvent("x5f84u"))
                        }

                        override fun onVideoCallWaiting() {
                            Log.d("AdjustEvent", "onVideoCallWaiting: ")
                            Adjust.trackEvent(AdjustEvent("5282di"))
                        }

                        override fun onVideoCallEnd() {
                            Log.d("AdjustEvent", "onVideoCallEnd: ")
                            Adjust.trackEvent(AdjustEvent("ys3bsp"))
                        }
                    })
                    result.success(true)
                }
                "marketRedirect" -> {
                    val marketIntent = Intent(
                        Intent.ACTION_VIEW, Uri.parse(
                            "market://details?id=com.unluco.piapiri"
                        )
                    )
                    marketIntent.addFlags(
                        Intent.FLAG_ACTIVITY_NO_HISTORY or Intent.FLAG_ACTIVITY_NEW_DOCUMENT or Intent.FLAG_ACTIVITY_MULTIPLE_TASK
                    )
                    this.startActivity(marketIntent)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        Insider.Instance.init(this.application, "piapiri");
    }
}