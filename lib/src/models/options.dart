class Options {
  String paymentMethods;

  Options({required this.paymentMethods});

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(paymentMethods: json['payment_methods']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_methods'] = paymentMethods;
    return data;
  }
}
