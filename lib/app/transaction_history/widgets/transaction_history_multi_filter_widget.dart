import 'package:design_system/components/button/button.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_filter_panel.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_main_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/transaction_history_account_filter_widget.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/transaction_type_filter_widget.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TransactionHistoryMultiFilterWidget extends StatefulWidget {
  final TransactionMainTypeEnum selectedTransactionMainType;
  final Function(TransactionHistoryTypeEnum, AccountModel) onSelectedTransactionTypeAndAccount;
  const TransactionHistoryMultiFilterWidget({
    super.key,
    required this.onSelectedTransactionTypeAndAccount,
    required this.selectedTransactionMainType,
  });

  @override
  State<TransactionHistoryMultiFilterWidget> createState() => _TransactionHistoryMultiFilterWidgetState();
}

class _TransactionHistoryMultiFilterWidgetState extends State<TransactionHistoryMultiFilterWidget> {
  final List<RadioModel> _sourcesList = [];
  int _selectedSourceIndex = 0;
  TransactionHistoryTypeEnum _transactionTypeEnum = TransactionHistoryTypeEnum.all;
  AccountModel _selectedAccount = UserModel.instance.accounts[0];

  @override
  void initState() {
    super.initState();

    _sourcesList.add(
      RadioModel(
        true,
        L10n.tr('direction_of_transaction'),
      ),
    );

    // if (widget.selectedTransactionMainType != TransactionMainTypeEnum.americanStockExchanges) {
    _sourcesList.add(
      RadioModel(
        false,
        L10n.tr('account_selection'),
      ),
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _sourcesWidget(),
              ),
              const SizedBox(
                width: Grid.s,
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 1,
                          color: context.pColorScheme.line,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: Grid.s,
                    ),
                    child: IndexedStack(
                      index: _selectedSourceIndex,
                      children: [
                        TransactionTypeFilterWidget(
                          transactionTypeEnum: _transactionTypeEnum,
                          onSelectedType: (selectedType) {
                            setState(() {
                              _transactionTypeEnum = selectedType;
                            });
                          },
                        ),
                        TransactionHistoryAccountFilterWildget(
                          selectedAccount: _selectedAccount,
                          onSelectedAccount: (selectedAccount) {
                            setState(() {
                              _selectedAccount = selectedAccount;
                            });
                          },
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          const SizedBox(
            height: Grid.m,
          ),
          PButton(
            text: L10n.tr('kaydet'),
            fillParentWidth: true,
            onPressed: () {
              widget.onSelectedTransactionTypeAndAccount(
                _transactionTypeEnum,
                _selectedAccount,
              );

              router.maybePop();
            },
          )
        ],
      ),
    );
  }

  Widget _sourcesWidget() {
    List<Widget> sourcesListWidget = [
      const SizedBox(
        height: Grid.s,
      )
    ];

    for (var i = 0; i < _sourcesList.length; i++) {
      sourcesListWidget.add(
        InkWell(
          splashColor: context.pColorScheme.transparent,
          highlightColor: context.pColorScheme.transparent,
          onTap: () {
            setState(() {
              if (_selectedSourceIndex == i) {
                _sourcesList[i].isSelected = true;
              } else {
                _sourcesList[i].isSelected = false;
              }
              _selectedSourceIndex = i;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: Grid.s + Grid.xs,
            ),
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: _selectedSourceIndex == i ? context.pColorScheme.primary : Colors.transparent,
                    border: Border.all(
                      width: 3.0,
                      color: _selectedSourceIndex == i ? context.pColorScheme.primary : Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Grid.xs + Grid.xxs,
                    ),
                    child: Text(
                      _sourcesList[i].text,
                      style: context.pAppStyle.interMediumBase.copyWith(
                        fontSize: Grid.m,
                        color:
                            _selectedSourceIndex == i ? context.pColorScheme.primary : context.pColorScheme.textPrimary,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sourcesListWidget,
    );
  }
}
