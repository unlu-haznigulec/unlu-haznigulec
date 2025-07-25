import 'package:auto_route/auto_route.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/selection_control/checkbox.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/agreements/bloc/agreements_bloc.dart';
import 'package:piapiri_v2/app/agreements/bloc/agreements_event.dart';
import 'package:piapiri_v2/app/agreements/bloc/agreements_state.dart';
import 'package:piapiri_v2/app/agreements/pages/agreements_form_card.dart';
import 'package:piapiri_v2/app/agreements/pages/agreements_instrument_list_widget.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/agreements_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class MyAggrementsFormPage extends StatefulWidget {
  final AgreementsModel reconcilition;
  final String overallDate;
  final bool isOutOfPeriod;
  final Function() onAggreement;
  const MyAggrementsFormPage({
    super.key,
    required this.reconcilition,
    required this.overallDate,
    required this.isOutOfPeriod,
    required this.onAggreement,
  });

  @override
  State<MyAggrementsFormPage> createState() => _MyAggrementsFormPageState();
}

class _MyAggrementsFormPageState extends State<MyAggrementsFormPage> {
  bool _isApproval = false;
  final UserModel _customerInfo = UserModel.instance;
  late AssetsBloc _assetsBloc;
  late AgreementsBloc _agreementsBloc;
  @override
  void initState() {
    _assetsBloc = getIt<AssetsBloc>();
    _agreementsBloc = getIt<AgreementsBloc>();
    _assetsBloc.add(
      GetOverallSummaryEvent(
        accountId: '',
        getInstant: false,
        overallDate: widget.overallDate,
        allAccounts: true,
        includeCashFlow: true,
        isFromAgreement: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: PBlocBuilder<AgreementsBloc, AgreementsState>(
        bloc: _agreementsBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr('mutabakat_formu'),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Grid.m,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: Grid.s),
                      AgreementFormCard(
                        reconcilition: widget.reconcilition,
                        fullname: _customerInfo.name,
                        customerExtId: _customerInfo.customerId ?? '',
                      ),
                      const SizedBox(height: Grid.xs + Grid.m),
                      PInfoWidget(
                        infoText: L10n.tr('my_aggrements_confirmation_text'),
                        infoTextStyle: context.pAppStyle.labelReg14textPrimary,
                      ),
                      const SizedBox(height: Grid.xs + Grid.m),
                      const AggrementsInstrumentListWidget(),
                      const SizedBox(height: Grid.m),
                      PCheckboxRow(
                        value: _isApproval,
                        removeCheckboxPadding: true,
                        label: L10n.tr(
                          'accept_portfolio',
                          args: [
                            DateTimeUtils.dateFormat(
                              DateTime.parse(widget.reconcilition.periodEndDate ?? DateTime.now().toString()),
                            ),
                          ],
                        ),
                        lableStyle: context.pAppStyle.labelReg14textPrimary,
                        onChanged: (bool? isSelected) {
                          setState(() {
                            _isApproval = isSelected!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            persistentFooterButtons: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.s,
                ),
                child: PButton(
                  loading: state.isLoading,
                  fillParentWidth: true,
                  sizeType: PButtonSize.small,
                  text: L10n.tr('mutabıkım'),
                  onPressed: !state.isLoading && _isApproval ? () => _doReconciliation() : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _doReconciliation() async {
    if (!_isApproval) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr('onay_secenegi_isaretlenmelidir'),
      );
    }

    _agreementsBloc.add(
      SetAgreementsEvent(
        accountId: _customerInfo.accountId,
        agreementPeriodId: widget.isOutOfPeriod ? '' : widget.reconcilition.periodId!,
        agreementPortfolioDate: widget.overallDate,
        onSuccess: () async {
          router.push(
            InfoRoute(
              variant: InfoVariant.success,
              message:
                  '${DateTimeUtils.dateFormat(DateTime.parse(widget.overallDate))} ${L10n.tr('portfoyunuz_uzerinden_verdiginiz_mutabakat_bildirimi_kaydedilmistir')}',
              onPressedCloseIcon: () => router.popUntilRouteWithName(
                AgreementsRoute.name,
              ),
            ),
          );
        },
      ),
    );
  }
}
