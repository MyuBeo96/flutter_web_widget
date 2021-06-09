import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:flutter/widgets.dart';
import 'package:flutter_web_widget/src/web_browser_impl.dart';
import 'package:flutter_web_widget/flutter_web_widget.dart';
import 'package:web_node/web_node.dart';

enum AutoMediaPlaybackPolicy {
  require_user_action_for_all_media_types,
  always_allow,
}

class CookieManager {}

class FlutterWebBrowserState extends State<FlutterWebBrowser> {
  Widget? _builtWidget;
  html.IFrameElement? _element;
  bool _didUpdate = true;

  @override
  Widget build(BuildContext context) {
    if (_builtWidget == null) {
      // Construct iframe
      _element = html.IFrameElement();
      _element!.style.backgroundColor = 'white';

      // Construct controller
      final controller = _WebBrowserController(_element);

      // Wrap iframe with navigation
      _builtWidget = wrapWebBrowser(
        context,
        widget,
        controller,
        WebNode(node: _element!),
      );

      final void Function(WebBrowserController)? onCreated = widget.onCreated;
      if (onCreated != null) {
        scheduleMicrotask(() {
          onCreated(_WebBrowserController(_element));
        });
      }
    }
    if (_didUpdate) {
      _didUpdate = false;
      final element = _element!;
      element.src = widget.initialUrl;
      widget.iframeSettings.applyToIFrameElement(element);
      final size = MediaQuery.of(context).size;
      element.height ??= '${size.height.toInt() - 100}';
      element.width ??= '${size.width.toInt()}';
    }
    return _builtWidget!;
  }

  @override
  void didUpdateWidget(FlutterWebBrowser oldWidget) {
    if (!(widget.initialUrl == oldWidget.initialUrl ||
        widget.iframeSettings != oldWidget.iframeSettings ||
        !identical(widget.onCreated, oldWidget.onCreated) ||
        !identical(widget.onError, oldWidget.onError))) {
      // Invalidate cached widget
      _didUpdate = true;
    }
    super.didUpdateWidget(oldWidget);
  }
}

class WebResourceError {
  final WebResourceErrorType? errorType;
  WebResourceError({this.errorType});
}

enum WebResourceErrorType {
  /// User authentication failed on server.
  authentication,
  badUrl,
  connect,
  failedSslHandshake,
  file,
  fileNotFound,
  hostLookup,
  io,
  proxyAuthentication,
  redirectLoop,
  timeout,
  tooManyRequests,
  unknown,
  unsafeResource,
  unsupportedAuthScheme,
  unsupportedScheme,
  webContentProcessTerminated,
  webViewInvalidated,
  javaScriptExceptionOccurred,
  javaScriptResultTypeIsUnsupported,
}

class _WebBrowserController extends WebBrowserController {
  final html.IFrameElement? _element;
  // ignore: close_sinks
  final _webNavigationEventController =
      StreamController<WebBrowserNavigationEvent>.broadcast();
  String? _url;

  _WebBrowserController(this._element) {
    _url = _element!.src;
  }

  @override
  Stream<WebBrowserNavigationEvent> get onNavigation =>
      _webNavigationEventController.stream;

  @override
  Future<String?> currentUrl() async {
    return _url;
  }

  @override
  Future<void> evaluateJavascript(String javascriptString) async {
    final window = _element!.contentWindow as js.JsObject;
    window.callMethod('eval', [javascriptString]);
  }

  @override
  Future<void> postMessage(dynamic message, String targetOrigin) async {
    _element!.contentWindow!.postMessage(message, targetOrigin);
  }

  @override
  Future<void> reload() async {
    _element?.contentWindow!.history.go(0);
  }
}
