import 'package:auto_route/auto_route.dart';
import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/place_holder/no_data_widget.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_add_data_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_blockage_model.dart';
import 'package:piapiri_v2/app/ipo/widgets/ipo_financial_instrument_data_source.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/core/utils/piapiri_loading.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

@RoutePage()
class IpoBlockageListPage extends StatefulWidget {
  final String deputyName;
  final String ipoId;
  final String paymentTypeName;
  final int paymentTypeId;
  final double ipoPrice;
  final String selectedAccount;
  final IpoAddDataModel addData;
  final Function(IpoAddDataModel) onChangedAddData;
  const IpoBlockageListPage({
    super.key,
    required this.deputyName,
    required this.ipoId,
    required this.paymentTypeName,
    required this.ipoPrice,
    required this.paymentTypeId,
    required this.selectedAccount,
    required this.addData,
    required this.onChangedAddData,
  });

  @override
  State<IpoBlockageListPage> createState() => _IpoBlockageListPageState();
}

// Blokaj
class _IpoBlockageListPageState extends State<IpoBlockageListPage> {
  late IpoBloc _bloc;
  FinancialInstrumentDataSource? _dataSource;
  late List<dynamic> columnNames;
  double _enteredValue = 0.0;
  double _remainingValue = 0.0;
  final DataGridController _dataGridController = DataGridController();
  bool _isKeyboardClosed = true;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _bloc = getIt<IpoBloc>();
    _focusNode.addListener(_onFocusChange);
    _bloc.add(
      GetBlockageEvent(
        customerId: widget.selectedAccount.split('-')[0],
        accountId: widget.selectedAccount.split('-')[1],
        ipoId: widget.ipoId,
        paymentType: widget.paymentTypeId,
      ),
    );

    // List<SettingsModel> marketSettings = _appInfoState.customerSettings.market;

    // columnNames = _getColumnsNew(marketSettings);
    _remainingValue = widget.ipoPrice;
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isKeyboardClosed = !_focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: PBlocConsumer<IpoBloc, IpoState>(
        bloc: _bloc,
        listenWhen: (previous, current) {
          return (previous.isLoading || previous.isFailed || previous.ipoBlockageModel == null) && current.isSuccess;
        },
        listener: (context, state) {
          _dataSource = FinancialInstrumentDataSource(
            controller: _dataGridController,
            financialInstrument: state.ipoBlockageModel!.financialInstrument!,
            amountText: '',
            paymentTypeId: widget.paymentTypeId,
            onChangeAmount: (String value) {
              setState(() {
                _isKeyboardClosed = false;

                _enteredValue = double.parse(value);
                _remainingValue = widget.ipoPrice - _enteredValue;
              });
            },
          );
        },
        builder: (context, state) {
          return Scaffold(
            appBar: PInnerAppBar(
              title: L10n.tr(widget.paymentTypeName),
            ),
            body: state.isLoading || state.isFailed || state.ipoBlockageModel == null || _dataSource == null
                ? const PLoading()
                : state.ipoBlockageModel!.financialInstrument!.isEmpty
                    ? Center(
                        child: NoDataWidget(
                          message: L10n.tr(
                            'ipo_blockage_list_empty_alert_by_name',
                            args: [
                              L10n.tr(widget.paymentTypeName),
                            ],
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Grid.m,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: Grid.m,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _middleColumnWidget(
                                      L10n.tr('ipo_amount'),
                                      MoneyUtils().readableMoney(widget.ipoPrice),
                                    ),
                                    _middleColumnWidget(
                                      L10n.tr('amount_entered'),
                                      MoneyUtils().readableMoney(_enteredValue),
                                    ),
                                    _middleColumnWidget(
                                      L10n.tr('amount_remaining'),
                                      MoneyUtils().readableMoney(
                                        _remainingValue < 0 ? 0 : _remainingValue,
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: Grid.s + Grid.xs,
                                  ),
                                  child: PDivider(),
                                ),
                                SfDataGrid(
                                  controller: _dataGridController,
                                  source: _dataSource!,
                                  navigationMode: GridNavigationMode.cell,
                                  headerRowHeight: 40,
                                  rowHeight: 60,
                                  columns: _getColumns(),
                                  verticalScrollPhysics: const BouncingScrollPhysics(),
                                  horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
                                  selectionMode: SelectionMode.none,
                                  shrinkWrapRows: true,
                                  gridLinesVisibility: GridLinesVisibility.none,
                                  headerGridLinesVisibility: GridLinesVisibility.none,
                                ),
                                SizedBox(height: _isKeyboardClosed ? 0 : kKeyboardHeight),
                              ],
                            ),
                          ),
                        ),
                      ),
            bottomNavigationBar: generalButtonPadding(
              context: context,
              child: state.ipoBlockageModel != null && state.ipoBlockageModel!.financialInstrument!.isEmpty
                  ? const SizedBox.shrink()
                  : PButton(
                      text: L10n.tr('devam'),
                      onPressed: _enteredValue == 0 ? null : () => _apply(state),
                    ),
            ),
          );
        },
      ),
    );
  }

  void _apply(IpoState state) async {
    if (_enteredValue < widget.ipoPrice) {
      return PBottomSheet.show(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Grid.m,
              ),
              child: Text(
                L10n.tr('ipo_blockage_less_than_alert'),
                textAlign: TextAlign.center,
                style: context.pAppStyle.labelReg16textPrimary,
              ),
            ),
          ],
        ),
      );
    } else if (_enteredValue > widget.ipoPrice) {
      return PBottomSheet.show(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Grid.m,
              ),
              child: Text(
                L10n.tr('ipo_blockage_more_than_alert'),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    } else {
      List<Map<String, dynamic>> itemsToBlock = [];
      for (var element in _dataGridController.selectedRows) {
        FinancialInstrument? instrument = state.ipoBlockageModel!.financialInstrument
            ?.firstWhere((e) => e.finInstName == element.getCells()[1].value.toString());
        itemsToBlock.add({
          'finInstName': element.getCells()[1].value.toString(),
          'demandAmount': element.getCells()[3].value,
          'rationalAmount': element.getCells()[2].value,
          'typeCode': instrument?.typeCode,
          'price': instrument?.price,
          'balance': instrument?.balance,
          'rationalDemandAmount': instrument?.rationalDemandAmount,
        });
      }

      widget.addData.itemsToBlock = itemsToBlock;

      widget.onChangedAddData(widget.addData);
      await router.maybePop();
      await router.maybePop();
      return;
    }
  }

  List<GridColumn> _getColumns() {
    return <GridColumn>[
      GridColumn(
        allowSorting: false,
        maximumWidth: 40,
        columnName: 'checkbox',
        allowEditing: false,
        label: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: Text(
            widget.paymentTypeId == 5
                ? L10n.tr('fund')
                : widget.paymentTypeId == 4
                    ? L10n.tr('currency')
                    : L10n.tr('hisse'),
            textAlign: TextAlign.left,
            style: context.pAppStyle.labelMed12textSecondary,
          ),
        ),
      ),
      GridColumn(
        columnWidthMode: ColumnWidthMode.fill,
        columnName: 'finInstName',
        allowEditing: false,
        label: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: const Text('')),
      ),
      GridColumn(
        columnWidthMode: ColumnWidthMode.fill,
        columnName: 'rationalAmount',
        allowEditing: false,
        label: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: Text(
            L10n.tr('bakiye'),
            textAlign: TextAlign.center,
            style: context.pAppStyle.labelMed12textSecondary,
          ),
        ),
      ),
      GridColumn(
        columnWidthMode: ColumnWidthMode.fill,
        allowEditing: true,
        allowFiltering: false,
        columnName: 'demandAmount',
        label: Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: Text(
            L10n.tr('blockage_amount'),
            textAlign: TextAlign.right,
            style: context.pAppStyle.labelMed12textSecondary,
          ),
        ),
      ),
    ];
  }

  Widget _middleColumnWidget(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.pAppStyle.labelMed12textSecondary,
        ),
        Text(
          '₺$value',
          style: context.pAppStyle.labelMed14textPrimary,
        ),
        const SizedBox(
          height: Grid.s,
        ),
      ],
    );
  }
}
