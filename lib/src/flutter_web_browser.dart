import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart' hide Element;
import 'package:flutter_web_widget/flutter_web_widget.dart';

import 'web_browser_impl_default.dart'
    if (dart.library.html) 'web_browser_impl_browser.dart' as impl;
import 'web_browser_impl_default.dart'
    if (dart.library.html) 'web_browser_impl_browser.dart'
    show WebResourceError;

export 'web_browser_impl_default.dart'
    if (dart.library.html) 'web_browser_impl_browser.dart'
    show
        AutoMediaPlaybackPolicy,
        WebResourceError,
        WebResourceErrorType,
        FlutterWebBrowserState;

class FlutterWebBrowser extends StatefulWidget {
  static const Set<Factory<OneSequenceGestureRecognizer>>
      _defaultGestureRecognizers = {
    Factory<HorizontalDragGestureRecognizer>(
      _horizontalDragGestureRecognizerFactory,
    ),
    Factory<VerticalDragGestureRecognizer>(
      _verticalDragGestureRecognizerFactory,
    ),
    Factory<TapGestureRecognizer>(
      _tapGestureRecognizerFactory,
    ),
  };

  /// Initial URL.
  final String initialUrl;

  /// Specifies `<iframe>` attributes.
  final WebBrowserIFrameSettings iframeSettings;

  final bool debuggingEnabled;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  final bool javascriptEnabled;

  /// Called when the web browser is ready.
  final void Function(WebBrowserController? controller)? onCreated;

  /// Called when an error occurs.
  final void Function(WebResourceError error)? onError;

  final String? userAgent;

  const FlutterWebBrowser({
    Key? key,
    required this.initialUrl,
    this.iframeSettings = const WebBrowserIFrameSettings(),
    this.debuggingEnabled = false,
    this.gestureRecognizers = _defaultGestureRecognizers,
    this.javascriptEnabled = false,
    this.onCreated,
    this.onError,
    this.userAgent,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return impl.FlutterWebBrowserState();
  }

  static HorizontalDragGestureRecognizer
      _horizontalDragGestureRecognizerFactory() =>
          HorizontalDragGestureRecognizer();

  static TapGestureRecognizer _tapGestureRecognizerFactory() =>
      TapGestureRecognizer();

  static VerticalDragGestureRecognizer
      _verticalDragGestureRecognizerFactory() =>
          VerticalDragGestureRecognizer();
}
