class Options {
  String? paymentMethods;
  String? currency;

  Options({this.paymentMethods, this.currency});

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(
        paymentMethods: json['payment_methods'], currency: json['currency']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_methods'] = paymentMethods;
    data['currency'] = currency;
    return data;
  }
}
