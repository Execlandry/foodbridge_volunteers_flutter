import 'order.dart';

class AvailableOrder {
  final String id;
  final String orderId;
  final Order order;

  AvailableOrder({
    required this.id,
    required this.orderId,
    required this.order,
  });

  factory AvailableOrder.fromJson(Map<String, dynamic> json) {
    return AvailableOrder(
      id: json['id'],
      orderId: json['order_id'],
      order: Order.fromJson(json['order']),
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'id': id,
    'order_id': orderId,
    'order': order.toJson(),
  };
}
}
