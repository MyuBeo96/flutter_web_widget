# flutter_web_widget

FlutterWebWidget widget for Flutter written in 100% Dart. Supports Android, iOS, Web.

## Getting Started

Setting up 
1.Setup 

In pubspec.yaml:

dependencies:
  flutter_web_widget: ^0.0.1
2.Display web browser 

import 'package:flutter/material.dart';
import 'package:web_browser/web_browser.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: FlutterWebBrowser(
          initialUrl: 'https://flutter.dev/',
        ),
      ),
    ),
  ));
}
