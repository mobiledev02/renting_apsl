class CustomerCard {
  int? id;
  String customerId;
  String last4;
  String brand;
  bool selected;

  CustomerCard(
      {required this.customerId,
      required this.last4,
      required this.brand,
        this.id,
      required this.selected});

  factory CustomerCard.fromJson(Map<String, dynamic> json) {
    return CustomerCard(
        customerId: json['customer_id'],
        id: json['id'],
        last4: json['last_digits'] ?? "",
        brand: json['card_type'] ?? "",
        selected: json['selected'] ?? false);
  }
}
