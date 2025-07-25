import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/in_app_webview_widget.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';

class TradingviewAndroidWidget extends StatefulWidget {
  final String symbol;
  final String exchangeName;

  const TradingviewAndroidWidget({
    super.key,
    required this.symbol,
    required this.exchangeName,
  });

  @override
  State<TradingviewAndroidWidget> createState() => _TradingviewAndroidWidgetState();
}

class _TradingviewAndroidWidgetState extends State<TradingviewAndroidWidget> {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String theme = getIt<AppInfoBloc>().state.appTheme == ThemeMode.dark ? 'dark' : 'light';
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        children: [
          InAppWebviewWidget(
            text: '''
        <div class="tradingview-widget-container"><div class="tradingview-widget-container__widget"></div><script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-advanced-chart.js" async>{
            "autosize": true,
            "symbol": "${widget.exchangeName}:${widget.symbol}",
                "interval": "D",
                "timezone": "Etc/UTC",
                "theme": "$theme",
                "style": "1",
                "locale": "en",
                "enable_publishing": false,
                "allow_symbol_change": false,
                "support_host": "https://www.tradingview.com"
              }</script></div>
            ''',
            id: widget.symbol,
            shouldParse: false,
            addHtmlTag: false,
            onLoadStart: () {
              setState(() {
                _isLoading.value = true;
              });
            },
            onLoadEnd: () {
              setState(() {
                _isLoading.value = false;
              });
            },
          ),
          ValueListenableBuilder(
            valueListenable: _isLoading,
            builder: (context, loading, child) {
              return loading ? const PLoading() : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
