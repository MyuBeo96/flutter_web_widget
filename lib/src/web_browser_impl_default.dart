import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_web_widget/src/web_browser_impl.dart';
import 'package:flutter_web_widget/flutter_web_widget.dart';
import 'package:webview_flutter/webview_flutter.dart' as web_view;

import '../flutter_web_widget.dart';

export 'package:webview_flutter/platform_interface.dart'
    show WebResourceError, WebResourceErrorType;
export 'package:webview_flutter/webview_flutter.dart'
    show AutoMediaPlaybackPolicy, CookieManager;

class FlutterWebBrowserState extends State<FlutterWebBrowser> {
  Widget? _builtWidget;
  _WebBrowserController? _controller;

  @override
  Widget build(BuildContext context) {
    if (_builtWidget == null) {
      _controller = _WebBrowserController(this);
      final webView = web_view.WebView(
        initialUrl: widget.initialUrl,
        debuggingEnabled: widget.debuggingEnabled,
        gestureRecognizers: widget.gestureRecognizers,
        javascriptMode: widget.javascriptEnabled
            ? web_view.JavascriptMode.unrestricted
            : web_view.JavascriptMode.disabled,
        onWebViewCreated: (webViewController) {
          _controller!._controller = webViewController;
          if (widget.onCreated != null) {
            widget.onCreated!(_controller);
          }
        },
        onWebResourceError: widget.onError,
        navigationDelegate: (request) {
          if (request.isForMainFrame) {
            _controller!._dispatchNavigation(request.url);
          }
          return web_view.NavigationDecision.navigate;
        },
      );
      _builtWidget = wrapWebBrowser(
        context,
        widget,
        _controller!,
        webView,
      );
    }
    return _builtWidget!;
  }

  @override
  void didUpdateWidget(FlutterWebBrowser oldWidget) {
    if (widget.initialUrl != oldWidget.initialUrl ||
        widget.debuggingEnabled != oldWidget.debuggingEnabled ||
        widget.iframeSettings != oldWidget.iframeSettings ||
        widget.javascriptEnabled != oldWidget.javascriptEnabled ||
        !identical(widget.onCreated, oldWidget.onCreated) ||
        !identical(widget.onError, oldWidget.onError)) {
      _builtWidget = null;
    }
    super.didUpdateWidget(oldWidget);
  }
}

class _WebBrowserController extends WebBrowserController {
  final FlutterWebBrowserState state;
  web_view.WebViewController? _controller;

  final _webNavigationEventController =
      StreamController<WebBrowserNavigationEvent>.broadcast();

  // ignore: close_sinks
  _WebBrowserController(this.state);

  @override
  Stream<WebBrowserNavigationEvent> get onNavigation =>
      _webNavigationEventController.stream;

  @override
  Future<String?> currentUrl() {
    if (_controller == null) {
      return Future<String>.value(state.widget.initialUrl);
    }
    return _controller!.currentUrl();
  }

  @override
  Future<void>? evaluateJavascript(String javascriptString) {
    return _controller?.evaluateJavascript(javascriptString);
  }

  @override
  Future<void> postMessage(dynamic message, String targetOrigin) async {
    throw UnimplementedError();
  }

  @override
  Future<void>? reload() {
    return _controller?.reload();
  }

  void _dispatchNavigation(String url) {
    _webNavigationEventController.add(WebBrowserNavigationEvent(this, url));
  }
}
