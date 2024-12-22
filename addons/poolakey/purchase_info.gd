class_name PurchaseInfo
extends RefCounted

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
