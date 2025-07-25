import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/consistent_equivalence.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/p_symbol_tile.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';

import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IpoUpdateWidget extends StatefulWidget {
  final IpoDemandModel myDemandedIpo;
  const IpoUpdateWidget({
    super.key,
    required this.myDemandedIpo,
  });

  @override
  State<IpoUpdateWidget> createState() => _IpoUpdateWidgetState();
}

class _IpoUpdateWidgetState extends State<IpoUpdateWidget> {
  final TextEditingController _orderUnitTC = TextEditingController();
  double _amount = 0;
  final FocusNode _focusNodeUnit = FocusNode(canRequestFocus: false);
  late IpoBloc _ipoBloc;

  @override
  void initState() {
    _ipoBloc = getIt<IpoBloc>();
    _orderUnitTC.text = widget.myDemandedIpo.unitsDemanded!.toInt().toString();
    _amount = (widget.myDemandedIpo.unitsDemanded ?? 0) * (widget.myDemandedIpo.offerPrice ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PSymbolTile(
          variant: PSymbolVariant.equityTab,
          symbolName: widget.myDemandedIpo.name ?? '',
          symbolType: SymbolTypes.equity,
          title: widget.myDemandedIpo.name,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
          child: PDivider(),
        ),
        Row(
          children: [
            Text(
              '${L10n.tr('ipo_price')}: ',
              style: context.pAppStyle.labelMed12textSecondary,
            ),
            const SizedBox(
              width: Grid.xs,
            ),
            Text(
              '₺${MoneyUtils().readableMoney(widget.myDemandedIpo.offerPrice ?? 0)}',
              style: context.pAppStyle.labelMed14textPrimary,
            )
          ],
        ),
        const SizedBox(
          height: Grid.l,
        ),
        Column(
          children: [
            PValueTextfieldWidget(
              controller: _orderUnitTC,
              title: L10n.tr('adet'),
              onFocusChange: (value) {
                if (!value) {}
              },
              focusNode: _focusNodeUnit,
              onChanged: (deger) {
                setState(() {
                  _orderUnitTC.text = deger.toString();

                  _amount = int.parse(deger) * (widget.myDemandedIpo.offerPrice ?? 0);
                });
              },
              onSubmitted: (value) {
                setState(() {
                  _orderUnitTC.text = value;
                  FocusScope.of(context).unfocus();
                });
              },
              onTapOutside: (value) {
                FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(
              height: Grid.s,
            ),
            /// Tutar gosterilen alan yetersiz limitte hata verir
            ConsistentEquivalence(
              title: L10n.tr('estimated_amount'),
              titleValue: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(_amount)}',
            ),
            const SizedBox(
              height: Grid.m,
            ),
            OrderApprovementButtons(
              cancelButtonText: L10n.tr('vazgeç'),
              onPressedCancel: () => router.maybePop(),
              approveButtonText: L10n.tr('onayla'),
              onPressedApprove: () async {
                if (_orderUnitTC.text.isEmpty || _orderUnitTC.text == '0') {
                  return PBottomSheet.show(
                    context,
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            ImagesPath.alertCircle,
                            width: 52,
                            height: 52,
                            colorFilter: ColorFilter.mode(
                              context.pColorScheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(
                            height: Grid.s,
                          ),
                          Text(
                            L10n.tr('please_enter_unit'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                _ipoBloc.add(
                  DemandUpdateEvent(
                    customerId: widget.myDemandedIpo.accountExtId!.split('-')[0],
                    accountId: widget.myDemandedIpo.accountExtId!.split('-')[1],
                    functionName: 1,
                    demandDate: DateTime.now().formatToJson(),
                    ipoId: widget.myDemandedIpo.ipoId!,
                    demandId: widget.myDemandedIpo.ipoDemandId!,
                    unitsDemanded: double.parse(_orderUnitTC.text.replaceAll(',', '')),
                    offerPrice: widget.myDemandedIpo.offerPrice ?? 0,
                    checkLimit: true,
                    demandGatheringType: 'M',
                    demandType: 'DEFINITE',
                    callback: () async {
                      getIt<IpoBloc>().add(
                        GetActiveListEvent(
                          pageNumber: 0,
                        ),
                      );

                      router.push(
                        InfoRoute(
                          variant: InfoVariant.success,
                          message: L10n.tr('order_update_success'),
                        ),
                      );

                      await router.maybePop();
                      await router.maybePop();
                      await router.maybePop();
                    },
                  ),
                );
              },
            ),
            KeyboardUtils.customViewInsetsBottom(),
          ],
        ),
      ],
    );
  }
}
