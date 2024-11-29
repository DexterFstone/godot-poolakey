@icon("res://addons/poolakey/logo.svg")
class_name Poolakey
extends Node

signal connection_succeed
signal connection_failed(message: String)
signal disconnected
signal purchase_flow_began
signal failed_to_begin_flow(message: String)
signal purchase_succeed(purchase_info: Poolakey.PurchaseInfo)
signal purchase_canceled
signal purchase_failed(message: String)
signal consume_succeed
signal consume_failed(message: String)
signal purchased_query_succeed(items: Array[Poolakey.PurchaseInfo])
signal purchased_query_failed(message: String)
signal subscribed_query_succeed(items: Array[Poolakey.PurchaseInfo])
signal subscribed_query_failed(message: String)
signal get_sku_details_succeed(items: Array[Poolakey.SkuDetails])
signal get_sku_details_failed(message: String)

@export var public_key: String

static var _plugin: JNISingleton
static var _plugin_name: String = "GodotPoolakey"

func _ready() -> void:
	connect_to_cafebazaar()

func connect_to_cafebazaar(public_key: String = "") -> void:
	if self.public_key.is_empty():
		self.public_key = public_key
	if self.public_key.is_empty(): return
	if not _has_singleton(): return
	_plugin = _get_singleton()
	_plugin.connect_to_cafebazaar(self.public_key)
	if not _plugin.is_connected("connection_succeed", __on_connection_succeed):
		_plugin.connection_succeed.connect(__on_connection_succeed, CONNECT_ONE_SHOT)
	if not _plugin.is_connected("connection_failed", __on_connection_failed):
		_plugin.connection_failed.connect(__on_connection_failed, CONNECT_ONE_SHOT)
	if not _plugin.is_connected("disconnected", __on_disconnected):
		_plugin.disconnected.connect(__on_disconnected, CONNECT_ONE_SHOT)

func purchase_product(product_id: String, payload: String = "", dynamic_price_token: String = "") -> void:
	if not _has_poolakey(): return
	_plugin.purchase_product(product_id, payload, dynamic_price_token)
	if not _plugin.is_connected("purchase_flow_began", __on_purchase_flow_began):
		_plugin.purchase_flow_began.connect(__on_purchase_flow_began, CONNECT_ONE_SHOT)
	if not _plugin.is_connected("failed_to_begin_flow", __on_failed_to_begin_flow):
		_plugin.failed_to_begin_flow.connect(__on_failed_to_begin_flow, CONNECT_ONE_SHOT)
	if not _plugin.is_connected("purchase_succeed", __on_purchase_succeed):
		_plugin.purchase_succeed.connect(__on_purchase_succeed, CONNECT_ONE_SHOT)
	if not _plugin.is_connected("purchase_canceled", __on_purchase_canceled):
		_plugin.purchase_canceled.connect(__on_purchase_canceled, CONNECT_ONE_SHOT)
	if not _plugin.is_connected("purchase_failed", __on_purchase_failed):
		_plugin.purchase_failed.connect(__on_purchase_failed, CONNECT_ONE_SHOT)

func subscribe_product(product_id: String, payload: String = "", dynamic_price_token: String = "") -> void:
	if not _has_poolakey(): return
	_plugin.purchase_product(product_id, payload, dynamic_price_token)
	if not _plugin.is_connected("purchase_flow_began", __on_purchase_flow_began):
		_plugin.purchase_flow_began.connect(__on_purchase_flow_began, CONNECT_ONE_SHOT)
	if not _plugin.is_connected("failed_to_begin_flow", __on_failed_to_begin_flow):
		_plugin.failed_to_begin_flow.connect(__on_failed_to_begin_flow, CONNECT_ONE_SHOT)
	if not _plugin.is_connected("purchase_succeed", __on_purchase_succeed):
		_plugin.purchase_succeed.connect(__on_purchase_succeed, CONNECT_ONE_SHOT)
	if not _plugin.is_connected("purchase_canceled", __on_purchase_canceled):
		_plugin.purchase_canceled.connect(__on_purchase_canceled, CONNECT_ONE_SHOT)
	if not _plugin.is_connected("purchase_failed", __on_purchase_failed):
		_plugin.purchase_failed.connect(__on_purchase_failed, CONNECT_ONE_SHOT)

func consume_product(purchase_info: PurchaseInfo) -> void:
	if not _has_poolakey(): return
	var purchase_token: String = purchase_info.purchase_token
	_plugin.consume_product(purchase_token)
	if not _plugin.is_connected("consume_succeed", __on_consume_succeed):
		_plugin.consume_succeed.connect(__on_consume_succeed, CONNECT_ONE_SHOT)
	if not _plugin.is_connected("consume_failed", __on_consume_failed):
		_plugin.consume_failed.connect(__on_consume_failed, CONNECT_ONE_SHOT)

func get_purchased_products() -> void:
	if not _has_poolakey(): return
	_plugin.get_purchased_products()
	if not _plugin.is_connected("purchased_query_succeed", __on_purchased_query_succeed):
		_plugin.purchased_query_succeed.connect(__on_purchased_query_succeed, CONNECT_ONE_SHOT)
	if not _plugin.is_connected("purchased_query_failed", __on_purchased_query_failed):
		_plugin.purchased_query_failed.connect(__on_purchased_query_failed, CONNECT_ONE_SHOT)

func get_subscribed_products() -> void:
	if not _has_poolakey(): return
	_plugin.get_subscribed_products()
	if not _plugin.is_connected("subscribed_query_succeed", __on_subscribed_query_succeed):
		_plugin.subscribed_query_succeed.connect(__on_subscribed_query_succeed, CONNECT_ONE_SHOT)
	if not _plugin.is_connected("subscribed_query_failed", __on_subscribed_query_failed):
		_plugin.subscribed_query_failed.connect(__on_subscribed_query_failed, CONNECT_ONE_SHOT)

func get_in_app_sku_details(item_skus: Array[String]) -> void:
	if not _has_poolakey(): return
	_plugin.get_in_app_sku_details(item_skus)
	if not _plugin.is_connected("get_sku_details_succeed", __on_get_sku_details_succeed):
		_plugin.get_sku_details_succeed.connect(__on_get_sku_details_succeed)
	if not _plugin.is_connected("get_sku_details_failed", __on_get_sku_details_failed):
		_plugin.get_sku_details_failed.connect(__on_get_sku_details_failed)

func disconnect_from_cafebazaar() -> void:
	if not _has_poolakey(): return
	_plugin.disconnect_from_cafebazaar()

static func _has_poolakey() -> bool:
	return is_instance_valid(_plugin)

func _has_singleton() -> bool:
	return Engine.has_singleton(_plugin_name)

func _get_singleton() -> Object:
	return Engine.get_singleton(_plugin_name)

func __on_connection_succeed() -> void:
	connection_succeed.emit()

func __on_connection_failed(message: String) -> void:
	connection_failed.emit(message)

func __on_disconnected() -> void:
	disconnected.emit()

func __on_purchase_flow_began() -> void:
	purchase_flow_began.emit()

func __on_failed_to_begin_flow(message: String) -> void:
	failed_to_begin_flow.emit(message)

func __on_purchase_succeed(info: Dictionary) -> void:
	var purchase_info: PurchaseInfo = PurchaseInfo.new(info)
	purchase_succeed.emit(info)

func __on_purchase_canceled() -> void:
	purchase_canceled.emit()

func __on_purchase_failed(message: String) -> void:
	purchase_failed.emit(message)

func __on_consume_succeed() -> void:
	consume_succeed.emit()

func __on_consume_failed(message: String) -> void:
	consume_failed.emit(message)

func __on_purchased_query_succeed(items: Dictionary) -> void:
	var purchase_info_list: Array[PurchaseInfo]
	for value: Dictionary in items.values():
		var purchase_info: PurchaseInfo = PurchaseInfo.new(value)
		purchase_info_list.append(purchase_info)
	purchased_query_succeed.emit(purchase_info_list)

func __on_purchased_query_failed(message: String) -> void:
	purchased_query_failed.emit(message)

func __on_subscribed_query_succeed(items: Dictionary) -> void:
	var purchase_info_list: Array[PurchaseInfo]
	for value: Dictionary in items.values():
		var purchase_info: PurchaseInfo = PurchaseInfo.new(value)
		purchase_info_list.append(purchase_info)
	subscribed_query_succeed.emit(purchase_info_list)

func __on_subscribed_query_failed(message: String) -> void:
	subscribed_query_failed.emit(message)

func __on_get_sku_details_succeed(items: Dictionary) -> void:
	var sku_details_list: Array[SkuDetails]
	for value: Dictionary in items.values():
		var sku_details: SkuDetails = SkuDetails.new(value)
		sku_details_list.append(sku_details)
	get_sku_details_succeed.emit(sku_details_list)

func __on_get_sku_details_failed(message: String) -> void:
	get_sku_details_failed.emit(message)

class SkuDetails extends RefCounted:

	var sku: String
	var type: String
	var price: String
	var title: String
	var description: String

	func _init(info: Dictionary) -> void:
		sku = info.get("sku")
		type = info.get("type")
		price = info.get("price")
		title = info.get("title")
		description = info.get("description")

class PurchaseInfo extends RefCounted:

	enum PurchaseState {
		PURCHASED,
		REFUNDED,
	}

	var order_id: String
	var purchase_token: String
	var payload: String
	var package_name: String
	var purchase_state: PurchaseState
	var purchase_time: int
	var product_id: String
	var original_json: String
	var data_signature: String

	func _init(info: Dictionary) -> void:
		order_id = info.get("order_id")
		purchase_token = info.get("purchase_token")
		payload = info.get("payload")
		package_name = info.get("package_name")
		purchase_state = info.get("purchase_state")
		purchase_time = info.get("purchase_time")
		product_id = info.get("product_id")
		original_json = info.get("original_json")
		data_signature = info.get("data_signature")

class Intent extends RefCounted:

	static func show_details(package_name: String = "") -> void:
		if not Poolakey._has_poolakey(): return
		Poolakey._plugin.show_intent_details(package_name)

	static func show_collection(developer_id: String) -> void:
		if not Poolakey._has_poolakey(): return
		Poolakey._plugin.show_intent_collection(developer_id)

	static func show_login() -> void:
		if not Poolakey._has_poolakey(): return
		Poolakey._plugin.show_intent_login()

	static func show_update() -> void:
		if not Poolakey._has_poolakey(): return
		Poolakey._plugin.show_intent_update()
