class ServiceChatKey {
  String renterId;
  String lenderId;
  String serviceId;
  String id;

  ServiceChatKey(
      {required this.serviceId,
      required this.lenderId,
      required this.id,
      required this.renterId});

  factory ServiceChatKey.fromJson(Map<String, dynamic> json, String id) {
    return ServiceChatKey(
      serviceId: json['service_id'],
      lenderId: json['lender_id'],
      id: json['id'],
      renterId: json['renter_id'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'service_id' : serviceId,
      'lender_id' : lenderId,
      'renter_id' : renterId,
      'id' : id
    };
  }
}
