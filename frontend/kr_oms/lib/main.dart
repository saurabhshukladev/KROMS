import 'package:flutter/material.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KROMS',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'KROMS', url: 'https://oms-2024.herokuapp.com/'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.url});

  final String title;
  final String url;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebViewController _controller;
  num position = 1 ;

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();


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

  

@override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        key: _key,

        appBar: AppBar(
          
  
          title: Text(widget.title),
          actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () async {
                    _controller.loadUrl('https://oms-2024.herokuapp.com/cart');
                  },  
                ),
              ]),
        
        body: SafeArea(
            child: WebView(
          key: UniqueKey(),
          onWebViewCreated: (WebViewController webViewController) {
            _controllerCompleter.future.then((value) => _controller = value);
            _controllerCompleter.complete(webViewController);
          },
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        )),
        
        drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
            accountName: Text("Hello, User"),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  NetworkImage("https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png"),
            ),
          ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                // Update the state of the app
                _controller.loadUrl('https://oms-2024.herokuapp.com/');
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Account'),
              onTap: () {
                // Update the state of the app
                _controller.loadUrl('https://oms-2024.herokuapp.com/account/profile');
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Orders'),
              onTap: () {
                // Update the state of the app
                _controller.loadUrl('https://oms-2024.herokuapp.com/userOrders');
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // Update the state of the app
                _controller.loadUrl('https://oms-2024.herokuapp.com/logout');
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Login/Sign Up'),
              onTap: () {
                // Update the state of the app
                _controller.loadUrl('https://oms-2024.herokuapp.com/loginForm');
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      ),
    );
  }
}