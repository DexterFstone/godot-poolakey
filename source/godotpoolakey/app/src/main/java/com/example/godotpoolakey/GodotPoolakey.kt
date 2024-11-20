package com.example.godotpoolakey

import androidx.collection.ArraySet
import ir.cafebazaar.poolakey.Payment
import ir.cafebazaar.poolakey.config.PaymentConfiguration
import ir.cafebazaar.poolakey.config.SecurityCheck
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot

class GodotPoolakey(godot: Godot?) : GodotPlugin(godot) {
    private lateinit var payment: Payment

    override fun getPluginName(): String {
        return "GodotPoolakey"
    }

    override fun getPluginSignals(): MutableSet<SignalInfo> {
        val signals: MutableSet<SignalInfo> = ArraySet()
        signals.add(SignalInfo("connection_succeed"))
        signals.add(SignalInfo("connection_failed", String::class.java))
        signals.add(SignalInfo("disconnected"))
        return signals
    }

    @UsedByGodot
    fun connect_to_cafebazaar(public_key: String) {
        godot.runOnUiThread(Runnable {

        })
        val localSecurityCheck = SecurityCheck.Enable(
            rsaPublicKey = public_key
        )
        val paymentConfiguration = PaymentConfiguration(
            localSecurityCheck = localSecurityCheck
        )
        payment = Payment(context = activity!!, config = paymentConfiguration)
        val paymentConnection = payment.connect {
            connectionSucceed {
                emitSignal("connection_succeed")
            }
            connectionFailed { throwable ->
                emitSignal("connection_failed", throwable.message)
            }
            disconnected {
                emitSignal("disconnected")
            }
        }
    }
}