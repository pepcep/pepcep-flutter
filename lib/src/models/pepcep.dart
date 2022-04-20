import 'package:pepcep_flutter/src/models/options.dart';

class Pepcep {
  List items;
  String email;
  Options? options;

  Pepcep({required this.items, required this.email, this.options});

  factory Pepcep.fromJson(Map<String, dynamic> json) {
    return Pepcep(
        items: json['items'],
        email: json['email'],
        options: json['options'] != null
            ? Options.fromJson(json['options'])
            : Options.fromJson({}));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items'] = items;
    data['email'] = email;
    data['options'] = options!.toJson();
    return data;
  }
}
