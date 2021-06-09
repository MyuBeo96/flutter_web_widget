import 'package:csp/csp.dart';
import 'package:universal_html/html.dart' show IFrameElement;
import 'package:flutter_web_widget/flutter_web_widget.dart';

/// Settings for iframes.
class WebBrowserIFrameSettings {
  final WebBrowserFeaturePolicy? allow;
  final Csp? csp;
  final String? height;
  final String? importance;
  final String? referrerPolicy;
  final String? sandbox;
  final String? scrolling;
  final String? width;

  const WebBrowserIFrameSettings({
    this.allow,
    this.csp,
    this.height,
    this.importance,
    this.referrerPolicy,
    this.sandbox,
    this.scrolling,
    this.width,
  });

  @override
  int get hashCode =>
      allow.hashCode ^
      csp.hashCode ^
      height.hashCode ^
      importance.hashCode ^
      referrerPolicy.hashCode ^
      sandbox.hashCode ^
      scrolling.hashCode ^
      width.hashCode;

  @override
  bool operator ==(other) =>
      other is WebBrowserIFrameSettings &&
      allow == other.allow &&
      csp == other.csp &&
      height == other.height &&
      importance == other.importance &&
      referrerPolicy == other.referrerPolicy &&
      sandbox == other.sandbox &&
      scrolling == other.scrolling &&
      width == other.width;

  void applyToIFrameElement(IFrameElement element) {
    final cspSourceString = csp?.toSourceString() ?? '';
    if (cspSourceString != element.csp) {
      element.csp = cspSourceString;
    }
    final height = this.height ?? '';
    if (height != element.height) {
      element.height = height;
    }
    final width = this.width ?? '';
    if (width != element.width) {
      element.width = width;
    }
    final allow = this.allow ?? '';
    if (allow != element.allow) {
      element.allow = allow.toString();
    }
    final referrerPolicy = this.referrerPolicy ?? '';
    if (referrerPolicy != element.referrerPolicy) {
      element.referrerPolicy = referrerPolicy;
    }
    final sandbox = this.sandbox;
    if (sandbox != element.getAttribute('sandbox')) {
      element.setAttribute('sandbox', sandbox!);
    }
    final importance = this.importance;
    if (importance != element.getAttribute('importance')) {
      element.setAttribute('importance', importance!);
    }
    final scrolling = this.scrolling;
    if (scrolling != element.getAttribute('scrolling')) {
      element.setAttribute('scrolling', scrolling!);
    }
  }
}
