import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:p_core/utils/platform_utils.dart';

class PInappViewer extends StatelessWidget {
  final String url;
  const PInappViewer({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    InAppWebViewController? webViewController;
    return InAppWebView(
      windowId: 10,
      initialSettings: InAppWebViewSettings(
        transparentBackground: true,
        useShouldOverrideUrlLoading: true,
        javaScriptCanOpenWindowsAutomatically: true,
      ),
      onWebViewCreated: (controller) {
        webViewController = controller;

        webViewController!.loadUrl(
          urlRequest: URLRequest(
            url: WebUri(url),
          ),
        );

        if (PlatformUtils.isAndroid) {
          InAppBrowser.openWithSystemBrowser(
            url: WebUri(url),
          );
        }
      },
      onPageCommitVisible: (con, uri) {
        con.goBack();
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        return navigationAction.request.url!.rawValue != 'about:blank'
            ? NavigationActionPolicy.ALLOW
            : NavigationActionPolicy.CANCEL;
      },
      onCreateWindow: (controller, createWindowAction) async {
        HeadlessInAppWebView? headlessWebView;
        headlessWebView = HeadlessInAppWebView(
          windowId: createWindowAction.windowId,
          onLoadStart: (controller, url) async {
            if (url != null) {
              InAppBrowser.openWithSystemBrowser(url: url);
            }
            await headlessWebView?.dispose();
            headlessWebView = null;
          },
        );
        headlessWebView?.run();
        return true;
      },
    );
  }
}
