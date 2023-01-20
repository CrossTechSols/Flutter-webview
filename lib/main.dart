import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Website',
      theme: ThemeData(
        primarySwatch: Colors.blue,


      ),
      home: MyHomePage(
          title: 'My Website',
          url: 'https://dorginals.takemyorder.io/login'),
    );

  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key? key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = true;
  late WebViewController _controller;

  final Completer<WebViewController> _controllerCompleter =
  Completer<WebViewController>();
  //Make sure this function return Future<bool> otherwise you will get an error
  Future<bool> _onWillPop(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(
      duration,
          () {
        setState(() {
          loading = false;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(

          body: loading == true
              ? Center(
            child: Image(image: AssetImage("assets/funkycraft.png")),

          )
        : SafeArea(
            child: WebView(
              key: UniqueKey(),
              onWebViewCreated: (WebViewController webViewController) {
                _controllerCompleter.future.then((value) => _controller = value);
                _controllerCompleter.complete(webViewController);
              },
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
            )),
      ),
    );
  }
}