package com.example.godotpoolakey

import android.util.Log
import androidx.collection.ArraySet
import androidx.fragment.app.FragmentActivity
import ir.cafebazaar.poolakey.Connection
import ir.cafebazaar.poolakey.Payment
import ir.cafebazaar.poolakey.config.PaymentConfiguration
import ir.cafebazaar.poolakey.config.SecurityCheck
import ir.cafebazaar.poolakey.entity.PurchaseInfo
import ir.cafebazaar.poolakey.entity.SkuDetails
import ir.cafebazaar.poolakey.request.PurchaseRequest
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot

class GodotPoolakey(godot: Godot?) : GodotPlugin(godot) {
    private lateinit var paymentConnection: Connection
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
        signals.add(SignalInfo("consume_succeed"))
        signals.add(SignalInfo("consume_failed", String::class.java))
        signals.add(SignalInfo("purchased_query_succeed", Dictionary::class.java))
        signals.add(SignalInfo("purchased_query_failed", String::class.java))
        signals.add(SignalInfo("subscribed_query_succeed", Dictionary::class.java))
        signals.add(SignalInfo("subscribed_query_failed", String::class.java))
        signals.add(SignalInfo("get_sku_details_succeed", Dictionary::class.java))
        signals.add(SignalInfo("get_sku_details_failed", String::class.java))
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
        paymentConnection = payment.connect {
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

    @UsedByGodot
    fun subscribe_product(product_id: String, payload: String, dynamic_price_token: String) {
        val purchaseRequest = PurchaseRequest(
            productId = product_id,
            payload = payload,
            dynamicPriceToken = dynamic_price_token
        )
        val fragment: FragmentActivity = activity as FragmentActivity
        payment.subscribeProduct(
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

    @UsedByGodot
    fun consume_product(purchase_token: String) {
        payment.consumeProduct(purchase_token) {
            consumeSucceed {
                emitSignal("consume_succeed")
            }
            consumeFailed { throwable ->
                emitSignal("consume_failed", throwable.message)
            }
        }
    }

    @UsedByGodot
    fun get_purchased_products() {
        payment.getSubscribedProducts {
            querySucceed { purchasedProducts ->
                val products: Dictionary = Dictionary()
                Log.d("godot", "get_purchased_products: $purchasedProducts")
                for (purchasedProduct: PurchaseInfo in purchasedProducts) {
                    val product: Dictionary = Dictionary()
                    product.put("order_id", purchasedProduct.orderId)
                    product.put("purchase_token", purchasedProduct.purchaseToken)
                    product.put("payload", purchasedProduct.payload)
                    product.put("package_name", purchasedProduct.packageName)
                    product.put("purchase_state", purchasedProduct.purchaseState)
                    product.put("purchase_time", purchasedProduct.purchaseTime)
                    product.put("product_id", purchasedProduct.productId)
                    product.put("original_json", purchasedProduct.originalJson)
                    product.put("data_signature", purchasedProduct.dataSignature)
                    products.put(purchasedProduct.orderId, product)
                }
                emitSignal("purchased_query_succeed", products)
            }
            queryFailed { throwable ->
                emitSignal("purchased_query_failed", throwable.message)
            }
        }
    }

    @UsedByGodot
    fun get_subscribed_products() {
        payment.getSubscribedProducts {
            querySucceed { purchasedProducts ->
                val products: Dictionary = Dictionary()
                for (purchasedProduct: PurchaseInfo in purchasedProducts) {
                    val product: Dictionary = Dictionary()
                    product.put("order_id", purchasedProduct.orderId)
                    product.put("purchase_token", purchasedProduct.purchaseToken)
                    product.put("payload", purchasedProduct.payload)
                    product.put("package_name", purchasedProduct.packageName)
                    product.put("purchase_state", purchasedProduct.purchaseState)
                    product.put("purchase_time", purchasedProduct.purchaseTime)
                    product.put("product_id", purchasedProduct.productId)
                    product.put("original_json", purchasedProduct.originalJson)
                    product.put("data_signature", purchasedProduct.dataSignature)
                    products.put(purchasedProduct.orderId, product)
                }
                emitSignal("subscribed_query_succeed", products)
            }
            queryFailed { throwable ->
                emitSignal("subscribed_query_failed", throwable.message)
            }
        }
    }

    @UsedByGodot
    fun disconnect_from_cafebazaar() {
        paymentConnection.disconnect()
    }

    @UsedByGodot
    fun get_in_app_sku_details(skuids: Array<String>) {
        val list: List<String> = skuids.toList()
        payment.getInAppSkuDetails(list) {
            getSkuDetailsSucceed { skuDetails ->
                val products: Dictionary = Dictionary()
                for (sku: SkuDetails in skuDetails) {
                    val product: Dictionary = Dictionary()
                    product.put("sku", sku.sku)
                    product.put("type", sku.type)
                    product.put("price", sku.price)
                    product.put("title", sku.title)
                    product.put("description", sku.description)
                    products.put(sku.sku, product)
                }
                emitSignal("get_sku_details_succeed", products)
            }
            getSkuDetailsFailed { throwable ->
                emitSignal("get_sku_details_failed", throwable.message)
            }
        }
    }
}

