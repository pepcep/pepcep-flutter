import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pepcep_flutter/src/helpers/custom_trace.dart';
import 'package:pepcep_flutter/src/models/options.dart';
import 'package:pepcep_flutter/src/models/pepcep.dart';
import 'package:pepcep_flutter/src/widgets/circular_loader.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PepcepFlutter extends StatefulWidget {
  const PepcepFlutter({
    Key? key,
    required this.apiKey,
    required this.subDomain,
    required this.appBarText,
    required this.email,
    this.options,
    required this.items,
    this.showAppBar = false,
    this.debugMode = false,
    this.onError,
    this.onSuccess,
  }) : super(key: key);

  final String apiKey;
  final String subDomain;
  final String appBarText;
  final String email;
  final Options? options;
  final List items;
  final bool debugMode;
  final bool showAppBar;
  final ValueChanged<String>? onError;
  final ValueChanged<String>? onSuccess;

  @override
  _PepcepFlutterState createState() => _PepcepFlutterState();
}

class _PepcepFlutterState extends State<PepcepFlutter> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey webViewKey = GlobalKey();
  late WebViewController webViewController;

  bool processing = true;
  bool pageMounted = false;

  late String paymentUrl;
  late String paymentSession;
  late String successUrl;
  late String cancelUrl;
  late String gateway;

  @override
  void initState() {
    super.initState();
    initializePayment();
  }

  String getParsedUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.host + uri.path + uri.fragment;
  }

  initializePayment() async {
    final client = http.Client();
    Pepcep pepcep = Pepcep(
        email: widget.email, items: widget.items, options: widget.options);

    final response = await client.post(
      Uri.parse('https://api.pepcep.com/v1/payments/initialize'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'API-KEY': widget.apiKey,
        'SUB-DOMAIN': widget.subDomain,
      },
      body: json.encode(pepcep.toJson()),
    );

    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedJSON = {};

        decodedJSON =
            json.decode(response.body)['data'] as Map<String, dynamic>;

        setState(() {
          processing = false;
          paymentUrl = decodedJSON["payment_url"];
          paymentSession = decodedJSON["session_id"];
          successUrl = decodedJSON["success_url"];
          cancelUrl = decodedJSON["cancel_url"];
          gateway = decodedJSON["gateway"];
        });

        print(CustomTrace(StackTrace.current, message: response.body));
        return;
      } else {
        widget.onError?.call(response.body);
        if (widget.debugMode) {
          print(CustomTrace(StackTrace.current, message: response.body));
        }
      }
    } on FormatException catch (e) {
      widget.onError?.call(e.toString());
      if (widget.debugMode) {
        print(CustomTrace(StackTrace.current, message: e.toString()));
      }
    }
  }

  JavascriptChannel _javascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'parent',
        onMessageReceived: (JavascriptMessage message) {
          if (widget.debugMode) {
            print(CustomTrace(StackTrace.current,
                message: message.message.toString()));
          }
          if (message.message == "paymentSuccess") {
            widget.onSuccess?.call(message.message);
          } else if (message.message == "paymentError") {
            widget.onError?.call(message.message);
          } else {}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                widget.appBarText,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .merge(const TextStyle(letterSpacing: 1.3)),
              ),
            )
          : null,
      body: Stack(
        children: [
          if (!pageMounted) ...[
            const Center(
              child: CircularLoader(height: 200),
            )
          ],
          if (!processing) ...[
            WebView(
              initialUrl: paymentUrl,
              gestureNavigationEnabled: true,
              onProgress: (progress) {},
              onWebViewCreated: (controller) {
                setState(() {
                  webViewController = controller;
                });
              },
              onPageFinished: (url) {
                setState(() {
                  pageMounted = true;
                });
              },
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: <JavascriptChannel>{
                _javascriptChannel(context),
              },
              navigationDelegate: (action) {
                String uri = action.url;
                if (uri.contains("close")) {
                  ///
                  /// close - https://standard.paystack.co/close
                  ///
                  webViewController.goBack();
                }
                return NavigationDecision.navigate;
              },
            ),
          ],
        ],
      ),
    );
  }
}
