class Pepcep {
  List items;
  String email;

  Pepcep({required this.items, required this.email});

  factory Pepcep.fromJson(Map<String, dynamic> json) {
    return Pepcep(items: json['items'], email: json['email']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items'] = items;
    data['email'] = email;
    return data;
  }
}
