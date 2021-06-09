class WebBrowserFeaturePolicy {
  final bool autoplay;
  final bool camera;
  final bool geolocation;
  final bool fullscreen;
  final bool payment;
  final bool publicKeyCredentialsGet;

  const WebBrowserFeaturePolicy({
    this.autoplay = false,
    this.camera = false,
    this.geolocation = false,
    this.fullscreen = false,
    this.payment = false,
    this.publicKeyCredentialsGet = false,
  });

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(other) =>
      other is WebBrowserFeaturePolicy && toString() == other.toString();

  @override
  String toString() {
    final list = <String>[];
    if (autoplay) {
      list.add('autoplay');
    }
    if (camera) {
      list.add('camera');
    }
    if (geolocation) {
      list.add('geolocation');
    }
    if (fullscreen) {
      list.add('fullscreen');
    }
    if (payment) {
      list.add('payment');
    }
    if (publicKeyCredentialsGet) {
      list.add('publickey-credentials-get');
    }
    return list.join(' ');
  }
}
