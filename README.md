# Pepcep Flutter

[![pub package](https://img.shields.io/pub/v/pepcep_flutter.svg)](https://pub.dartlang.org/packages/pepcep_flutter)

A Flutter plugin for integrating Pepcep. Fully supports Android and iOS.


## Installation

Run

```yaml
flutter pub add pepcep_flutter
```

Import in your project:

```dart
import 'package:pepcep_flutter/pepcep_flutter.dart';
```

## Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:pepcep_flutter/pepcep_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pepcep Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool proceedToPayment = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _proceeedToPayment() {
    setState(() {
      proceedToPayment = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: proceedToPayment
          ? null
          : AppBar(
              title: const Text("Purchase Info"),
            ),
      body: proceedToPayment
          ? PepcepFlutter(
              debugMode: true,
              apiKey: "<PEPCEP_API_KEY>",
              subDomain: "example.pepcep.com",
              appBarText: "Purchase Payment",
              email: "johndoe@example.com",
              items: const [
                {"name": "T-Shirt", "amount": 40000},
              ],
              onSuccess: (data) {
                /// Redirect user to success page with `data`
                setState(() {
                  proceedToPayment = false;
                });
              },
              onError: (data) {
                /// Redirect user to error page with `data`
                setState(() {
                  proceedToPayment = false;
                });
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _proceeedToPayment,
                    child: const Text(
                      "Proceed to Payment",
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
```


## Properties

Here is a list of properties available:

|          Name          |   Type   | Required |                            Description                            |
| :--------------------: | :------: | :------: | :---------------------------------------------------------------: |
|       apiKey           |  String  |   true   |                     your pepcep public api key                    |
|       subDomain        |  String  |   true   |                     your pepcep public subdomain                  |
|       appBarText       |  String  |  false   |                 the title of the widget's appbar                  |
|        email           |  String  |   true   |                         customer email                            |
|        items           |   List   |   true   |                     list of purchased items                       |
|       onError          | Function |   true   |                 callback to run on payment error                  |
|       onSuccess        | Function |   true   |                callback to run on payment success                 |
|       debugMode        |   bool   |  false   |                 to enable or disable package logs                 |


# Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
