import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/chip/chip.dart';
import 'package:design_system/components/place_holder/no_data_widget.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_event.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_state.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/in_app_webview_widget.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/notification_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';

@RoutePage()
class NotificationDetailPage extends StatefulWidget {
  final NotificationModel selectedNotification;
  const NotificationDetailPage({
    super.key,
    required this.selectedNotification,
  });

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  final NotificationsBloc _notificationBloc = getIt<NotificationsBloc>();

  InAppWebViewController? webViewController;

  @override
  void initState() {
    _notificationBloc.add(
      NotificationDetailEvent(
        notificationId: widget.selectedNotification.notificationId,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<NotificationsBloc, NotificationsState>(
      bloc: _notificationBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr('notification_detail'),
            ),
            body: const PLoading(),
          );
        }

        if (state.notificationDetailModel == null) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr('notification_detail'),
            ),
            body: NoDataWidget(
              message: L10n.tr('no_data'),
            ),
          );
        }

        bool isEmptySymbolTags =
            state.notificationDetailModel!.symbolTags == null || state.notificationDetailModel!.symbolTags!.isEmpty;

        return Scaffold(
          appBar: PInnerAppBar(
            title: L10n.tr('notification_detail'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Grid.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Grid.s,
                        right: Grid.s,
                        bottom: Grid.s,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.selectedNotification.title,
                            textAlign: TextAlign.start,
                            style: context.pAppStyle.labelMed16textPrimary,
                          ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                          Text(
                            '${DateTimeUtils.dateFormat(
                              DateTime.parse(
                                widget.selectedNotification.createdDay,
                              ),
                            )}, ${DateTimeUtils.strTimeFromDate(
                              date: DateTime.parse(
                                widget.selectedNotification.createdTime,
                              ),
                            )}',
                            style: context.pAppStyle.labelMed14textSecondary,
                          ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                          if (!isEmptySymbolTags)
                            SizedBox(
                              height: 30,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: state.notificationDetailModel?.symbolTags!.length,
                                itemBuilder: (context, index) {
                                  return PSymbolChip(
                                    label: state.notificationDetailModel!.symbolTags![index],
                                    chipSize: ChipSize.small,
                                    svgPath:
                                        '${getIt<AppInfo>().cdnUrl}icons/${symbolTypeToCdnHandle(SymbolTypes.equity)}/${state.notificationDetailModel!.symbolTags![index]}.svg',
                                    onPressed: () {
                                      getIt<SymbolBloc>().add(
                                        SymbolDetailPageEvent(
                                          symbolData: MarketListModel(
                                            symbolCode: state.notificationDetailModel!.symbolTags![index],
                                            updateDate: DateTime.now().toString(),
                                            type: SymbolTypes.equity.name,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                          if (state.notificationDetailModel!.externalLink!.isNotEmpty)
                            InkWell(
                              onTap: () => router.push(
                                NotificationDetailWebViewRoute(
                                  url: state.notificationDetailModel!.externalLink!,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: Grid.s),
                                child: Text(
                                  L10n.tr('click_for_detail'),
                                ),
                              ),
                            ),
                          if (state.notificationDetailModel!.fileUrl!.isNotEmpty)
                            InkWell(
                              onTap: () => router.push(
                                NotificationDetailPdfRoute(
                                  pdfUrl: state.notificationDetailModel!.fileUrl!,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: Grid.s),
                                child: Text(
                                  L10n.tr('click_for_file'),
                                ),
                              ),
                            ),
                          if (state.notificationDetailModel!.content != null)
                            _contentInAppWebview(state.notificationDetailModel!.content!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: isEmptySymbolTags
              ? const SizedBox.shrink()
              : generalButtonPadding(
                  context: context,
                  child: Row(
                    spacing: Grid.s,
                    children: [
                      Expanded(
                        child: PButton(
                          text: L10n.tr('al'),
                          sizeType: PButtonSize.medium,
                          variant: PButtonVariant.success,
                          onPressed: () {
                            String selectedSymbol = '';

                            if (state.notificationDetailModel!.symbolTags!.length > 1) {
                              _showMultiSymbolTags(
                                state.notificationDetailModel!.symbolTags!,
                                OrderActionTypeEnum.buy,
                                L10n.tr('hangi_sembolu_almak_istiyorsunuz'),
                              );
                            } else {
                              selectedSymbol = state.notificationDetailModel!.symbolTags![0];

                              router.push(
                                CreateOrderRoute(
                                  symbol: MarketListModel(
                                    symbolCode: selectedSymbol,
                                    updateDate: '',
                                  ),
                                  action: OrderActionTypeEnum.buy,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: PButton(
                          text: L10n.tr('sat'),
                          sizeType: PButtonSize.medium,
                          variant: PButtonVariant.error,
                          onPressed: () {
                            if (state.notificationDetailModel!.symbolTags!.length > 1) {
                              _showMultiSymbolTags(
                                state.notificationDetailModel!.symbolTags!,
                                OrderActionTypeEnum.sell,
                                L10n.tr('hangi_sembolu_satmak_istiyorsunuz'),
                              );
                            } else {
                              router.push(
                                CreateOrderRoute(
                                  symbol: MarketListModel(
                                    symbolCode: state.notificationDetailModel!.symbolTags![0],
                                    updateDate: '',
                                  ),
                                  action: OrderActionTypeEnum.sell,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: Grid.xs,
                          ),
                          child: POutlinedButton(
                            text: L10n.tr('my_orders'),
                            sizeType: PButtonSize.small,
                            onPressed: () {
                              router.popUntilRoot();

                              getIt<TabBloc>().add(
                                const TabChangedEvent(
                                  tabIndex: 1,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _contentInAppWebview(String content) {
    Random random = Random();
    int randomNumber = random.nextInt(100);

    return Expanded(
      child: InAppWebviewWidget(
        text: content,
        id: randomNumber.toString(),
      ),
    );
  }

  _showMultiSymbolTags(
    List<String> symbolTags,
    OrderActionTypeEnum? action,
    String title,
  ) {
    return PBottomSheet.show(
      context,
      title: title,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: symbolTags.length,
        separatorBuilder: (context, index) => const PDivider(),
        itemBuilder: (context, index) {
          final String symbolTag = symbolTags[index];

          return BottomsheetSelectTile(
            title: L10n.tr(
              symbolTag,
            ),
            isSelected: false,
            value: symbolTag,
            onTap: (title, value) {
              setState(() {
                router.push(
                  CreateOrderRoute(
                    symbol: MarketListModel(
                      symbolCode: value,
                      updateDate: '',
                    ),
                    action: action,
                  ),
                );
              });
              router.maybePop();
            },
          );
        },
      ),
    );
  }
}
