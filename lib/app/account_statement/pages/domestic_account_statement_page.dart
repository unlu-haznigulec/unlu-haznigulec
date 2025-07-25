import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/place_holder/no_data_widget.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/account_statement/bloc/account_statement_bloc.dart';
import 'package:piapiri_v2/app/account_statement/bloc/account_statement_event.dart';
import 'package:piapiri_v2/app/account_statement/bloc/account_statement_state.dart';
import 'package:piapiri_v2/app/account_statement/model/summary_type_enum.dart';
import 'package:piapiri_v2/app/account_statement/widgets/account_summary_tile.dart';
import 'package:piapiri_v2/app/account_statement/widgets/domestic_account_statement_filter_widget.dart';
import 'package:piapiri_v2/app/account_statement/widgets/shimmer_account_statement_widget.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_statement_date_filter_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DomesticAccountStatementPage extends StatefulWidget {
  const DomesticAccountStatementPage({super.key});

  @override
  State<DomesticAccountStatementPage> createState() => _DomesticAccountStatementPageState();
}

class _DomesticAccountStatementPageState extends State<DomesticAccountStatementPage> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _selectedAccount = 'tum_hesaplar';
  late final AccountStatementBloc _accountStatementBloc;
  SummaryTypeEnum _selectedSummaryType = SummaryTypeEnum.allExtract;
  DateFilterMultiEnum _selectedDate = DateFilterMultiEnum.sumaryToday;

  @override
  void initState() {
    _accountStatementBloc = getIt<AccountStatementBloc>();
    _accountStatementBloc.add(
      GetAccountTransactionsEvent(
        selectedAccount: _selectedAccount,
        transactionType: _selectedSummaryType.value,
        startDate: _startDate.formatToJson(),
        endDate: _endDate.formatToJson(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DomesticAccountStatementFilters(
            selectedAccount: _selectedAccount,
            selectedSummaryType: _selectedSummaryType,
            selectedDate: _selectedDate,
            onChangedAccount: (selectedAccount) {
              setState(() {
                _selectedAccount = selectedAccount;
                _accountStatementBloc.add(
                  GetAccountTransactionsEvent(
                    selectedAccount: _selectedAccount,
                    transactionType: _selectedSummaryType.value,
                    startDate: _startDate.formatToJson(),
                    endDate: _endDate.formatToJson(),
                  ),
                );
              });
            },
            onChangedSummaryType: (summaryType) {
              setState(() {
                _selectedSummaryType = summaryType;
                _accountStatementBloc.add(
                  GetAccountTransactionsEvent(
                    selectedAccount: _selectedAccount,
                    transactionType: _selectedSummaryType.value,
                    startDate: _startDate.formatToJson(),
                    endDate: _endDate.formatToJson(),
                  ),
                );
              });
            },
            onChangedStartEndDate: (startDate, endDate) {
              setState(() {
                _startDate = startDate;
                _endDate = endDate;
                _accountStatementBloc.add(
                  GetAccountTransactionsEvent(
                    selectedAccount: _selectedAccount,
                    transactionType: _selectedSummaryType.value,
                    startDate: _startDate.formatToJson(),
                    endDate: _endDate.formatToJson(),
                  ),
                );
              });
            },
            onSelectedDateFilter: (selectedDateFilter) {
              setState(() {
                _selectedDate = selectedDateFilter;
              });
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: PBlocBuilder<AccountStatementBloc, AccountStatementState>(
              bloc: _accountStatementBloc,
              builder: (context, state) {
                if (state.isLoading) {
                  return const Shimmerize(
                    enabled: true,
                    child: ShimmerAccountStatementWidget(),
                  );
                }

                if (state.accountSummaryList.isEmpty || state.isFailed) {
                  return NoDataWidget(
                    message: L10n.tr('no_account_statements_found'),
                    iconName: ImagesPath.telescope_on,
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: Grid.s,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              L10n.tr('type_of_operation_instrument_date'),
                              textAlign: TextAlign.start,
                              style: context.pAppStyle.labelMed12textSecondary,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              L10n.tr('transaction_amount_type'),
                              textAlign: TextAlign.end,
                              style: context.pAppStyle.labelMed12textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Grid.s + Grid.xs,
                        ),
                        child: PDivider(),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.accountSummaryList.length,
                        itemBuilder: (context, index) {
                          return AccountSummaryTile(
                            accountSummary: state.accountSummaryList[index],
                            showDivider: index != state.accountSummaryList.length - 1,
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        PBlocBuilder<AccountStatementBloc, AccountStatementState>(
            bloc: _accountStatementBloc,
            builder: (context, state) {
              if (state.isLoading || state.accountSummaryList.isEmpty || state.isFailed) {
                return const SizedBox.shrink();
              }

              return PButtonWithIcon(
                text: L10n.tr('send_by_email'),
                height: 52,
                iconAlignment: IconAlignment.end,
                fillParentWidth: true,
                icon: SvgPicture.asset(
                  ImagesPath.arrow_up_right,
                  width: 17,
                  height: 17,
                  colorFilter: ColorFilter.mode(context.pColorScheme.card.shade50, BlendMode.srcIn),
                ),
                onPressed: () {
                  _sendMail();
                },
              );
            }),
        const SizedBox(
          height: Grid.m,
        ),
      ],
    );
  }

  void _sendMail() async {
    String accountId = '';

    if (_selectedAccount == L10n.tr('tum_hesaplar') || _selectedAccount == 'tum_hesaplar') {
      accountId = 'ALL';
    } else {
      accountId = _selectedAccount.split('-')[1];
    }

    _accountStatementBloc.add(
      SendCustomerStatementEvent(
        accountId: accountId,
        transactionType: _selectedSummaryType.value,
        startDate: DateTimeUtils.serverDate(_startDate),
        endDate: DateTimeUtils.serverDate(_endDate),
        onSuccess: (response) {
          router.push(
            InfoRoute(
              variant: InfoVariant.success,
              message: L10n.tr(
                'mail_gonderildi',
                args: [response],
              ),
            ),
          );

          router.popUntilRoot();
        },
      ),
    );
  }
}
