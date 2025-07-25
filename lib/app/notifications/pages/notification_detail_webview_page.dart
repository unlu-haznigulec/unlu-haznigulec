import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class NotificationDetailWebViewPage extends StatefulWidget {
  final String url;
  const NotificationDetailWebViewPage({super.key, required this.url});

  @override
  State<NotificationDetailWebViewPage> createState() => _NotificationDetailWebViewPageState();
}

class _NotificationDetailWebViewPageState extends State<NotificationDetailWebViewPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(title: L10n.tr('notification_detail')),
      body:
          InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(widget.url),
        ),
        initialSettings: InAppWebViewSettings(),
        onReceivedHttpError: (controller, request, response) {},
        onLoadStop: (controller, url) => setState(
          () {},
        ),
        onLoadStart: (controller, url) => setState(
          () {},
        ),
      ),
    );
  }
}
