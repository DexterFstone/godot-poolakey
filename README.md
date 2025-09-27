# راهنمای استفاده از Godot Poolakey Plugin

این پلاگین برای یکپارچه‌سازی سرویس خرید درون‌برنامه‌ای Poolakey با Godot استفاده می‌شود.
نسخه **4.5.0** پلاگین، تمام متدها را به صورت **static** ارائه می‌دهد و پاسخ‌ها از طریق `Callable` مدیریت می‌شوند.

## ایجاد اتصال به Poolakey

برای برقراری اتصال و آماده‌سازی عملیات خرید:

```gdscript
Poolakey.open_connection(PUBLIC_KEY,
    func connection_succeed() -> void:
        # اتصال موفق
    func connection_failed(message: String) -> void:
        # اتصال ناموفق
    func disconnected() -> void:
        # اتصال قطع شد
)
```

## خرید درون‌برنامه‌ای

برای خرید یک محصول:

```gdscript
Poolakey.purchase_product("product_id", "payload", "dynamic_price_token",
    func purchase_flow_began() -> void:
        # شروع فرآیند خرید
    func failed_to_begin_flow(message: String) -> void:
        # خطا در شروع فرآیند خرید
    func purchase_succeed(purchase: Poolakey.Purchase) -> void:
        # خرید موفق
    func purchase_canceled() -> void:
        # خرید لغو شد
    func purchase_failed(message: String) -> void:
        # خرید ناموفق
)
```

## اشتراک درون‌برنامه‌ای

```gdscript
Poolakey.subscribe_product("product_id", "payload", "dynamic_price_token",
    func purchase_flow_began() -> void:
        # شروع فرآیند اشتراک
    func failed_to_begin_flow(message: String) -> void:
        # خطا در شروع اشتراک
    func subscription_succeed(purchase: Poolakey.Purchase) -> void:
        # اشتراک موفق
    func subscription_canceled() -> void:
        # اشتراک لغو شد
    func subscription_failed(message: String) -> void:
        # اشتراک ناموفق
)
```

## مصرف خرید (Consume)

برای محصولاتی که قابلیت مصرف دارند:

```gdscript
Poolakey.consume_product(purchase,
    func consume_succeed() -> void:
        # مصرف موفق
    func consume_failed(message: String) -> void:
        # مصرف ناموفق
)
```

## استعلام محصولات و خریدهای کاربر

```gdscript
Poolakey.get_products(ITEM_SKUS,
    func products_query_succeed(products: Array[Poolakey.Product]) -> void:
        # استعلام موفق محصولات
    func products_query_failed(message: String) -> void:
        # استعلام ناموفق
)

Poolakey.get_purchased_products(
    func purchased_query_succeed(purchases: Array[Poolakey.Purchase]) -> void:
        # استعلام موفق خریدها
    func purchased_query_failed(message: String) -> void:
        # استعلام ناموفق خریدها
)

Poolakey.get_subscribed_products(
    func subscribed_query_succeed(subscriptions: Array[Poolakey.Purchase]) -> void:
        # استعلام موفق اشتراک‌ها
    func subscribed_query_failed(message: String) -> void:
        # استعلام ناموفق اشتراک‌ها
)
```

## بستن اتصال

پس از اتمام عملیات، اتصال را ببندید:

```gdscript
Poolakey.close_connection()
```

## کلاس‌های اصلی پلاگین

* کلاس **Product:** اطلاعات محصولات شامل `sku`, `type`, `price`, `title`, `description`.
* کلاس **Purchase:** اطلاعات خرید شامل `sku`, `order_id`, `purchase_time`, `developer_payload`, `signature`.

## نمایش صفحات Poolakey

* متد `Intent.show_details(package_name)` - نمایش جزئیات برنامه
* متد `Intent.show_collection(developer_id)` - نمایش مجموعه توسعه‌دهنده
* متد `Intent.show_login()` - نمایش صفحه ورود
* متد `Intent.show_update()` - نمایش صفحه بروزرسانی

## نکات مهم

* تمام متدها به صورت **static** هستند و پاسخ‌ها از طریق `Callable` مدیریت می‌شوند.
* قبل از هر عملیات، اتصال با `open_connection` باید برقرار شود.
* برای پاک‌سازی منابع، `close_connection` را فراخوانی کنید.

با این پلاگین می‌توانید خریدهای درون‌برنامه‌ای را به صورت ایمن و ساده در بازی‌ها و برنامه‌های Godot خود مدیریت کنید.
