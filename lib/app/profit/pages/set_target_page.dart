import 'package:auto_route/auto_route.dart';
import 'package:design_system/components/button/button.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_bloc.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_event.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

@RoutePage()
class SetTargetPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function() onSetTarget;
  const SetTargetPage({
    super.key,
    required this.data,
    required this.onSetTarget,
  });

  @override
  State<SetTargetPage> createState() => _SetTargetPageState();
}

class _SetTargetPageState extends State<SetTargetPage> {
  final TextEditingController _priceTC = TextEditingController();
  double _targetPrice = 1.0;
  DateTime _targetDate = DateTime.now();
  late ProfitBloc _profitBloc;
  @override
  void initState() {
    super.initState();
    _profitBloc = getIt<ProfitBloc>();
    _targetPrice = double.parse(widget.data['target_price'].toString()) == 0
        ? 1
        : double.parse(widget.data['target_price'].toString());
    _priceTC.text = MoneyUtils().editableMoney(_targetPrice);

    _targetDate = DateTime.parse(widget.data['target_date'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PInnerAppBar(
        title: 'target',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Grid.s),
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(Grid.m),
            color: context.pColorScheme.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'set_a_target',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: Grid.m),
                _priceWidget(),
                const SizedBox(height: Grid.s),
                _setDateWidget(),
                const SizedBox(height: Grid.s),
                PButton(
                  text: 'kaydet',
                  onPressed: () => _doSaveTarget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _doSaveTarget() async {
    _profitBloc.add(SetCustomerTargetEvent(
      target: _targetPrice,
      targetDate: _targetDate,
      onSuccess: () async {
        widget.onSetTarget();
        await router.maybePop();
      },
    ));
  }

  Widget _priceWidget() {
    return const SizedBox();
    //TODO: Implement StepperTextField
    // return Container(
    //   color: PColor.lightHigh.withOpacity(0.1),
    //   child: Focus(
    //     onFocusChange: (value) {
    //       setState(() {
    //         _priceTC.text = MoneyUtils().readableMoney(
    //           MoneyUtils().fromReadableMoney(_priceTC.text),
    //         );
    //       });
    //     },
    //     child: StepperTextField(
    //       controller: _priceTC,
    //       label: Utils.tr('fiyat'),
    //       onDecrease: () {
    //         setState(() {
    //           if (_targetPrice > 1) {
    //             _targetPrice -= 1;
    //             _priceTC.text = MoneyUtils().readableMoney(_targetPrice);
    //           }
    //         });
    //       },
    //       onIncrease: () {
    //         setState(() {
    //           _targetPrice += 1;
    //           _priceTC.text = MoneyUtils().readableMoney(_targetPrice);
    //         });
    //       },
    //       onFieldChanged: (value) {
    //         double money = MoneyUtils().fromReadableMoney(value);
    //         setState(() {
    //           _targetPrice = money;
    //           _priceTC.text = value;
    //         });
    //       },
    //     ),
    //   ),
    // );
  }

  Widget _setDateWidget() {
    return const SizedBox();
    //TODO: Implement DatePickerInput
    // return DatePickerInput(
    //   initialDate: _targetDate,
    //   color: PColor.lightHigh.withOpacity(0.1),
    //   minimumDate: DateTime.now(),
    //   maximumDate: DateTime.now().add(const Duration(days: 365)),
    //   onChanged: (choosenDate) {
    //     setState(() {
    //       _targetDate = choosenDate;
    //     });
    //   },
    //   title: 'target',
    // );
  }
}
