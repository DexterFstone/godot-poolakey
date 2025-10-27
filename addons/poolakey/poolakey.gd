@icon("res://addons/poolakey/logo.svg")
@abstract
class_name Poolakey
extends Object

static var _singleton: JNISingleton
static var _singleton_name: String = "GodotPoolakey"

## [codeblock]
## 	Poolakey.open_connection(PUBLIC_KEY,
## 		func connection_succeed() -> void:
## 			return, # Connection succeed
##
## 		func connection_failed(message: String) -> void:
## 			return, # Connection failed
##
## 		func disconnected() -> void:
## 			return # Disconnected
## 	)
## [/codeblock]
static func open_connection(public_key: String, succeed: Callable, failed: Callable, disconnected: Callable) -> void:
	if not _has_singleton():
		return
	
	_singleton = _get_singleton()
	_singleton.open_connection(public_key)
	
	var connection_succeed: Callable = func () -> void:
		succeed.call()
	
	var connection_failed: Callable = func (message: String) -> void:
		failed.call(message)
		
	var connection_disconnected: Callable = func () -> void:
		disconnected.call()
		
	if not _singleton.connection_succeed.is_connected(connection_succeed):
		_singleton.connection_succeed.connect(connection_succeed, CONNECT_ONE_SHOT)
	
	if not _singleton.connection_failed.is_connected(connection_failed):
		_singleton.connection_failed.connect(connection_failed, CONNECT_ONE_SHOT)
	
	if not _singleton.disconnected.is_connected(connection_disconnected):
		_singleton.disconnected.connect(connection_disconnected, CONNECT_ONE_SHOT)

## [codeblock]
## 	Poolakey.purchase_product("product_id", "payload", "dynamic_price_token",
## 		func purchase_flow_began() -> void:
## 			return, # Purchase flow began
##
## 		func failed_to_begin_flow(message: String) -> void:
## 			return, # Failed to begin flow
##
## 		func purchase_succeed(purchase: Poolakey.Purchase) -> void:
## 			return, # Purchase succeed
##
## 		func purchase_canceled() -> void:
## 			return, # Purchase canceled
##
## 		func purchase_failed(message: String) -> void:
## 			return # Purchase failed
## 	)
## [/codeblock]
static func purchase_product(product_id: String, payload: String, dynamic_price_token: String, flow_began: Callable, failed_to_begin: Callable, succeed: Callable, canceled: Callable, failed: Callable) -> void:
	if not _has_poolakey():
		return
	
	_singleton.purchase_product(product_id, payload, dynamic_price_token)
	
	var on_flow_began: Callable = func () -> void:
		flow_began.call()

	var on_failed_to_begin: Callable = func (message: String) -> void:
		failed_to_begin.call(message)

	var on_succeed: Callable = func (data: Dictionary) -> void:
		succeed.call(Purchase.new(data))
	
	var on_canceled: Callable = func () -> void:
		canceled.call()
	
	var on_failed: Callable = func (message: String) -> void:
		failed.call(message)
	
	if not _singleton.purchase_flow_began.is_connected(on_flow_began):
		_singleton.purchase_flow_began.connect(on_flow_began, CONNECT_ONE_SHOT)
	
	if not _singleton.failed_to_begin_flow.is_connected(on_failed_to_begin):
		_singleton.failed_to_begin_flow.connect(on_failed_to_begin, CONNECT_ONE_SHOT)
	
	if not _singleton.purchase_succeed.is_connected(on_succeed):
		_singleton.purchase_succeed.connect(on_succeed, CONNECT_ONE_SHOT)

	if not _singleton.purchase_canceled.is_connected(on_canceled):
		_singleton.purchase_canceled.connect(on_canceled, CONNECT_ONE_SHOT)

	if not _singleton.purchase_failed.is_connected(on_failed):
		_singleton.purchase_failed.connect(on_failed, CONNECT_ONE_SHOT)

## [codeblock]
## 	Poolakey.subscribe_product("product_id", "payload", "dynamic_price_token",
## 		func purchase_flow_began() -> void:
## 			return, # Subscription flow began
##
## 		func failed_to_begin_flow(message: String) -> void:
## 			return, # Failed to begin subscription flow
##
## 		func subscription_succeed(purchase: Poolakey.Purchase) -> void:
## 			return, # Subscription succeed
##
## 		func subscription_canceled() -> void:
## 			return, # Subscription canceled
##
## 		func subscription_failed(message: String) -> void:
## 			return # Subscription failed
## 	)
## [/codeblock]
static func subscribe_product(product_id: String, payload: String, dynamic_price_token: String, flow_began: Callable, failed_to_begin: Callable, succeed: Callable, canceled: Callable, failed: Callable) -> void:
	if not _has_poolakey():
		return
	
	_singleton.purchase_product(product_id, payload, dynamic_price_token)

	var on_flow_began: Callable = func () -> void:
		flow_began.call()
	
	var on_failed_to_begin: Callable = func (message: String) -> void:
		failed_to_begin.call(message)
	
	var on_succeed: Callable = func (data: Dictionary) -> void:
		succeed.call(Purchase.new(data))
	
	var on_canceled: Callable = func () -> void:
		canceled.call()
	
	var on_failed: Callable = func (message: String) -> void:
		failed.call(message)
	
	if not _singleton.purchase_flow_began.is_connected(on_flow_began):
		_singleton.purchase_flow_began.connect(on_flow_began, CONNECT_ONE_SHOT)

	if not _singleton.failed_to_begin_flow.is_connected(on_failed_to_begin):
		_singleton.failed_to_begin_flow.connect(on_failed_to_begin, CONNECT_ONE_SHOT)

	if not _singleton.purchase_succeed.is_connected(on_succeed):
		_singleton.purchase_succeed.connect(on_succeed, CONNECT_ONE_SHOT)

	if not _singleton.purchase_canceled.is_connected(on_canceled):
		_singleton.purchase_canceled.connect(on_canceled, CONNECT_ONE_SHOT)

	if not _singleton.purchase_failed.is_connected(on_failed):
		_singleton.purchase_failed.connect(on_failed, CONNECT_ONE_SHOT)

## [codeblock]
## 	Poolakey.consume_product(purchase,
## 		func consume_succeed() -> void:
## 			return, # Consume succeed
##
## 		func consume_failed(message: String) -> void:
## 			return # Consume failed
## 	)
## [/codeblock]
static func consume_product(purchase: Purchase, succeed: Callable, failed: Callable) -> void:
	if not _has_poolakey():
		return
	
	var purchase_token: String = purchase.purchase_token
	_singleton.consume_product(purchase_token)
	
	var consume_succeed: Callable = func () -> void:
		succeed.call()
	
	var consume_failed: Callable = func (message: String) -> void:
		failed.call(message)
	
	if not _singleton.consume_succeed.is_connected(consume_succeed):
		_singleton.consume_succeed.connect(consume_succeed, CONNECT_ONE_SHOT)

	if not _singleton.consume_failed.is_connected(consume_failed):
		_singleton.consume_failed.connect(consume_failed, CONNECT_ONE_SHOT)

## [codeblock]
## 	Poolakey.get_purchased_products(
## 		func purchased_query_succeed(purchases: Array[Poolakey.Purchase]) -> void:
## 			return, # Query purchased products succeed
##
## 		func purchased_query_failed(message: String) -> void:
## 			return # Query purchased products failed
## 	)
## [/codeblock]
static func get_purchased_products(succeed: Callable, failed: Callable) -> void:
	if not _has_poolakey():
		return
	
	_singleton.get_purchased_products()
	
	var query_succeed: Callable = func (data: Dictionary) -> void:
		var purchases: Array[Purchase]
		for purchase: Dictionary in data.values():
			var new_purchase: Purchase = Purchase.new(purchase)
			purchases.append(new_purchase)
		succeed.call(purchases)
	
	var query_failed: Callable = func (message: String) -> void:
		failed.call(message)
	
	if not _singleton.purchased_query_succeed.is_connected(query_succeed):
		_singleton.purchased_query_succeed.connect(query_succeed, CONNECT_ONE_SHOT)

	if not _singleton.purchased_query_failed.is_connected(query_failed):
		_singleton.purchased_query_failed.connect(query_failed, CONNECT_ONE_SHOT)

## [codeblock]
## 	Poolakey.get_subscribed_products(
## 		func subscribed_query_succeed(subscriptions: Array[Poolakey.Purchase]) -> void:
## 			return, # Query subscribed products succeed
##
## 		func subscribed_query_failed(message: String) -> void:
## 			return # Query subscribed products failed
## 	)
## [/codeblock]
static func get_subscribed_products(succeed: Callable, failed: Callable) -> void:
	if not _has_poolakey():
		return

	_singleton.get_subscribed_products()

	var query_succeed: Callable = func (data: Dictionary) -> void:
		var purchases: Array[Purchase]
		for purchase: Dictionary in data.values():
			var new_purchase: Purchase = Purchase.new(purchase)
			purchases.append(new_purchase)
		succeed.call(purchases)
	
	var query_failed: Callable = func (message: String) -> void:
		failed.call(message)
	
	if not _singleton.subscribed_query_succeed.is_connected(query_succeed):
		_singleton.subscribed_query_succeed.connect(query_succeed, CONNECT_ONE_SHOT)

	if not _singleton.subscribed_query_failed.is_connected(query_failed):
		_singleton.subscribed_query_failed.connect(query_failed, CONNECT_ONE_SHOT)

## [codeblock]
## 	Poolakey.get_products(ITEM_SKUS,
## 		func products_query_succeed(products: Array[Poolakey.Product]) -> void:
## 			return, # Query products succeed
##
## 		func products_query_failed(message: String) -> void:
## 			return # Query products failed
## 	)
## [/codeblock]
static func get_products(sku_ids: Array[String], succeed: Callable, failed: Callable) -> void:
	if not _has_poolakey():
		return

	_singleton.get_products(sku_ids)

	var query_succeed: Callable = func (data: Dictionary) -> void:
		var products: Array[Product]
		for product: Dictionary in data.values():
			var new_product: Product = Product.new(product)
			products.append(new_product)
		succeed.call(products)
	
	var query_failed: Callable = func (message: String) -> void:
		failed.call(message)
	
	if not _singleton.products_query_succeed.is_connected(query_succeed):
		_singleton.products_query_succeed.connect(query_succeed, CONNECT_ONE_SHOT)

	if not _singleton.products_query_failed.is_connected(query_failed):
		_singleton.products_query_failed.connect(query_failed, CONNECT_ONE_SHOT)


static func close_connection() -> void:
	if not _has_poolakey():
		return
	
	_singleton.close_connection()
	_singleton.free()
	_singleton = null


static func _has_poolakey() -> bool:
	return is_instance_valid(_singleton)


static func _has_singleton() -> bool:
	return Engine.has_singleton(_singleton_name)


static func _get_singleton() -> Object:
	return Engine.get_singleton(_singleton_name)

@abstract class Intent extends RefCounted:

	static func show_details(package_name: String = "") -> void:
		if not Poolakey._has_poolakey(): return
		Poolakey._singleton.show_intent_details(package_name)


	static func show_collection(developer_id: String) -> void:
		if not Poolakey._has_poolakey(): return
		Poolakey._singleton.show_intent_collection(developer_id)


	static func show_login() -> void:
		if not Poolakey._has_poolakey(): return
		Poolakey._singleton.show_intent_login()


	static func show_update() -> void:
		if not Poolakey._has_poolakey(): return
		Poolakey._singleton.show_intent_update()

class Product extends RefCounted:

	var sku: String:
		get = get_sku
	var type: String:
		get = get_type
	var price: String:
		get = get_price
	var title: String:
		get = get_title
	var description: String:
		get = get_description
	
	var _sku: String
	var _type: String
	var _price: String
	var _title: String
	var _description: String

	func _init(data: Dictionary) -> void:
		_sku = data.get("sku", "")
		_type = data.get("type", "")
		_price = data.get("price", "")
		_title = data.get("title", "")
		_description = data.get("description", "")


	func get_sku() -> String:
		return _sku


	func get_type() -> String:
		return _type


	func get_price() -> String:
		return _price


	func get_title() -> String:
		return _title


	func get_description() -> String:
		return _description

class Purchase extends RefCounted:

	enum PurchaseState {
		PURCHASED,
		REFUNDED,
	}

	var order_id: String:
		get = get_order_id
	var purchase_token: String:
		get = get_purchase_token
	var payload: String:
		get = get_payload
	var package_name: String:
		get = get_package_name
	var purchase_state: PurchaseState:
		get = get_purchase_state
	var purchase_time: int:
		get = get_purchase_time
	var product_id: String:
		get = get_product_id
	var original_json: String:
		get = get_original_json
	var data_signature: String:
		get = get_data_signature
	
	var _order_id: String
	var _purchase_token: String
	var _payload: String
	var _package_name: String
	var _purchase_state: PurchaseState
	var _purchase_time: int
	var _product_id: String
	var _original_json: String
	var _data_signature: String

	func _init(data: Dictionary) -> void:
		_order_id = data.get("order_id", "")
		_purchase_token = data.get("purchase_token", "")
		_payload = data.get("payload", "")
		_package_name = data.get("package_name", "")
		_purchase_state = data.get("purchase_state", -1)
		_purchase_time = data.get("purchase_time", 0)
		_product_id = data.get("product_id", "")
		_original_json = data.get("original_json", "")
		_data_signature = data.get("data_signature", "")


	func get_order_id() -> String:
		return _order_id


	func get_purchase_token() -> String:
		return _purchase_token


	func get_payload() -> String:
		return _payload


	func get_package_name() -> String:
		return _package_name


	func get_purchase_state() -> PurchaseState:
		return _purchase_state


	func get_purchase_time() -> int:
		return _purchase_time


	func get_product_id() -> String:
		return _product_id


	func get_original_json() -> String:
		return _original_json


	func get_data_signature() -> String:
		return _data_signature
