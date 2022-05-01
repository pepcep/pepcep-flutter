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
                {"name": "T-Shirt", "amount": "40000"},
              ],
              options: Options(currency: 'USD', paymentMethods: "banktransfer"),
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
