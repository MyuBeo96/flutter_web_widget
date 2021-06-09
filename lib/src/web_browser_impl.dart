import 'package:flutter/widgets.dart';
import 'package:flutter_web_widget/flutter_web_widget.dart';

Widget wrapWebBrowser(
  BuildContext context,
  FlutterWebBrowser webBrowser,
  WebBrowserController controller,
  Widget widget,
) {
  final columnChildren = <Widget>[];

  // Content
  columnChildren.add(
    Expanded(
      child: Focus(
        child: widget,
      ),
    ),
  );

  Widget result = Column(
    mainAxisSize: MainAxisSize.max,
    children: columnChildren,
  );

  // Inherited
  return WebBrowserControllerWidget(
    controller: controller,
    child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: result,
    ),
  );
}
