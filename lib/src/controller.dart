import 'package:flutter/widgets.dart';

abstract class WebBrowserController {
  Stream<WebBrowserNavigationEvent> get onNavigation;

  Future<String?> currentUrl();

  Future<void>? evaluateJavascript(String javascriptString);

  Future<void> postMessage(dynamic message, String targetOrigin);

  Future<void>? reload();

  static WebBrowserController of(BuildContext context) {
    final webBrowserControllerWidget = context
        .dependOnInheritedWidgetOfExactType<WebBrowserControllerWidget>()!;
    return webBrowserControllerWidget.controller;
  }
}

class WebBrowserControllerWidget extends InheritedWidget {
  final WebBrowserController controller;

  WebBrowserControllerWidget({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    if (oldWidget is WebBrowserControllerWidget) {
      return controller != oldWidget.controller;
    } else {
      return false;
    }
  }
}

class WebBrowserNavigationEvent {
  final WebBrowserController controller;
  final String url;
  WebBrowserNavigationEvent(this.controller, this.url);
}
