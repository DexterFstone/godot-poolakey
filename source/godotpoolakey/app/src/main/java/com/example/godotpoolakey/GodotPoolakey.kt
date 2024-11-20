package com.example.godotpoolakey

import androidx.collection.ArraySet
import androidx.fragment.app.FragmentActivity
import ir.cafebazaar.poolakey.Payment
import ir.cafebazaar.poolakey.config.PaymentConfiguration
import ir.cafebazaar.poolakey.config.SecurityCheck
import ir.cafebazaar.poolakey.request.PurchaseRequest
import org.godotengine.godot.Dictionary
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
        signals.add(SignalInfo("purchase_flow_began"))
        signals.add(SignalInfo("failed_to_begin_flow", String::class.java))
        signals.add(SignalInfo("purchase_succeed", Dictionary::class.java))
        signals.add(SignalInfo("purchase_canceled"))
        signals.add(SignalInfo("purchase_failed", String::class.java))
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

    @UsedByGodot
    fun purchase_product(product_id: String, payload: String, dynamic_price_token: String) {
        val purchaseRequest = PurchaseRequest(
            productId = product_id,
            payload = payload,
            dynamicPriceToken = dynamic_price_token
        )
        val fragment: FragmentActivity = activity as FragmentActivity
        payment.purchaseProduct(
            registry = fragment.activityResultRegistry,
            request = purchaseRequest
        ) {
            purchaseFlowBegan {
                emitSignal("purchase_flow_began")
            }
            failedToBeginFlow { throwable ->
                emitSignal("failed_to_begin_flow", throwable.message)
            }
            purchaseSucceed { purchaseEntity ->
                val purchase: Dictionary = Dictionary()
                purchase.put("order_id", purchaseEntity.orderId)
                purchase.put("purchase_token", purchaseEntity.purchaseToken)
                purchase.put("payload", purchaseEntity.payload)
                purchase.put("package_name", purchaseEntity.packageName)
                purchase.put("purchase_state", purchaseEntity.purchaseState.ordinal)
                purchase.put("purchase_time", purchaseEntity.purchaseTime)
                purchase.put("product_id", purchaseEntity.productId)
                purchase.put("original_json", purchaseEntity.originalJson)
                purchase.put("data_signature", purchaseEntity.dataSignature)
                emitSignal("purchase_succeed", purchase)
            }
            purchaseCanceled {
                emitSignal("purchase_canceled")
            }
            purchaseFailed { throwable ->
                emitSignal("purchase_failed", throwable.message)
            }
        }
    }
}