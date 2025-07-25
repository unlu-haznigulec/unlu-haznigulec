import 'package:auto_route/auto_route.dart';
import 'package:design_system/components/date/date.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/news/widgets/journal_instrument_list.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/in_app_webview_widget.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/news_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class JournalDetailPage extends StatefulWidget {
  final News news;
  final MarketListModel? symbol;
  final String appBarTitle;
  const JournalDetailPage({
    super.key,
    required this.news,
    this.symbol,
    required this.appBarTitle,
  });

  @override
  State<JournalDetailPage> createState() => _JournalDetailPageState();
}

class _JournalDetailPageState extends State<JournalDetailPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: 'news_detail');
  DateTime? _localtime = DateTime.now();
  late bool _isShowShareIcon;
  @override
  void initState() {
    _buttonControl();
    _localtime = DateTime.parse(widget.news.date!).toLocal();
    _isShowShareIcon = widget.news.content?.isNotEmpty == true;
    super.initState();
  }

  _buttonControl() async {
    if (widget.news.symbol != null && widget.news.symbol!.isNotEmpty) {}

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PInnerAppBar(
        title: widget.appBarTitle,
        actions: [
          Visibility(
            visible: _isShowShareIcon,
            child: InkWell(
              onTap: () => _shareNews(),
              child: SvgPicture.asset(
                ImagesPath.share,
                width: Grid.l,
                height: Grid.l,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.iconPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: Grid.m,
            right: Grid.m,
            top: Grid.m + Grid.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.news.headline ?? '',
                      textAlign: TextAlign.left,
                      style: context.pAppStyle.labelMed14textPrimary,
                    ),
                    const SizedBox(
                      height: Grid.m,
                    ),
                    PDate(
                      date: DateTime.parse(widget.news.date!)
                          .add(
                            Duration(
                              hours: _localtime!.timeZoneOffset.inHours,
                            ),
                          )
                          .formatDayMonthYearTimeWithComma(),
                    ),
                    const SizedBox(
                      height: Grid.m,
                    ),
                    widget.news.content == null || widget.news.content!.isEmpty
                        ? const SizedBox.shrink()
                        : Expanded(
                            child: InAppWebviewWidget(
                              text: widget.news.content!,
                              id: widget.news.id!,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.news.symbol == null
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(
                vertical: Grid.m + Grid.xxs,
                horizontal: Grid.m,
              ),
              decoration: BoxDecoration(
                color: context.pColorScheme.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: context.pColorScheme.textTeritary,
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: Grid.s + Grid.xs,
                children: [
                  Text(
                    L10n.tr('related_symbols'),
                    style: context.pAppStyle.labelMed14primary,
                  ),
                  JournalInstrumentList(
                    news: widget.news,
                    symbol: widget.symbol,
                    maxWidth: double.infinity,
                  ),
                ],
              ),
            ),
    );
  }

  _shareNews() async {
    String news = '';
    if (widget.news.content?.isNotEmpty == true) {
      news = widget.news.content!;
    }
    await Share.share(
      news,
      subject: widget.news.headline,
    );
  }

  buyOrSellCondition({
    required OrderActionTypeEnum orderAction,
    bool? isMaybePop,
  }) async {
    if (isMaybePop != null && isMaybePop) {
      await router.maybePop();
    }
    if (widget.news.symbol!.length > 1) {
      // showSelector(
      //   context: context,
      //   orderAction: orderAction,
      //   newsList: widget.news,
      // );
    } else if (widget.news.symbol!.length == 1) {
      // TODO: new buy sell page will be added
      // QuickOrder.showQuickOrder(
      //   context,
      //   symbolName: widget.news.symbol![0],
      //   orderActionType: orderAction,
      //   isInnerPage: true,
      // );
    }
  }
}
