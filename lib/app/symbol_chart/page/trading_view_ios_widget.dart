import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingviewiOSWidget extends StatefulWidget {
  final String symbol;
  final String exchangeName;

  const TradingviewiOSWidget({
    super.key,
    required this.symbol,
    required this.exchangeName,
  });

  @override
  State<TradingviewiOSWidget> createState() => _TradingviewiOSWidgetState();
}

class _TradingviewiOSWidgetState extends State<TradingviewiOSWidget> {
  String _theme = 'light';
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  @override
  void initState() {
    _theme = getIt<AppInfoBloc>().state.appTheme == ThemeMode.dark ? 'dark' : 'light';
    super.initState();
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onProgress: (progress) {
            _isLoading.value = true;
          },
          onPageFinished: (url) {
            _isLoading.value = false;
          },
        ),
      )
      ..loadHtmlString('''
          <meta name="viewport" content="initial-scale=0.8">
          <div class="tradingview-widget-container"><div class="tradingview-widget-container__widget"></div><script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-advanced-chart.js" async>{
            "autosize": true,
            "symbol": "${widget.exchangeName}:${widget.symbol}",
            "interval": "D",
            "timezone": "Etc/UTC",
            "theme": "$_theme",
            "style": "1",
            "locale": "en",
            "enable_publishing": false,
            "allow_symbol_change": false,
            "support_host": "https://www.tradingview.com"
          }</script></div>''');
    return Stack(
      children: [
        WebViewWidget(
          controller: controller,
        ),
        ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (context, loading, child) {
            return loading
                ? const PLoading()
                // const FloatingLoading(isLoading: true)
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
