import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/widgets/filter_category_button.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IpoAccountListWidget extends StatefulWidget {
  final List<String> accountItemList;
  final String selectedAccount;
  const IpoAccountListWidget({
    super.key,
    required this.accountItemList,
    required this.selectedAccount,
  });

  @override
  State<IpoAccountListWidget> createState() => _IpoAccountListWidgetState();
}

class _IpoAccountListWidgetState extends State<IpoAccountListWidget> {
  String _selectedAccount = '';

  @override
  void initState() {
    _selectedAccount = widget.selectedAccount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        List<Widget> accountListWidget = [];

        for (var i = 0; i < widget.accountItemList.length; i++) {
          accountListWidget.add(
            FilterCategoryButton(
              onTap: () {
                setState(() {
                  _selectedAccount = widget.accountItemList[i];

                  getIt<IpoBloc>().add(
                    GetTradeLimitEvent(
                      customerId: _selectedAccount.split('-')[0],
                      accountId: _selectedAccount.split('-')[1],
                    ),
                  );

                  getIt<IpoBloc>().add(
                    GetCashBalanceEvent(
                        customerId: _selectedAccount.split('-')[0],
                        accountId: _selectedAccount.split('-')[1],
                        typeName: 'CASH-T2'),
                  );

                  router.maybePop();
                });
              },
              title: widget.accountItemList[i],
              isSelected: _selectedAccount == widget.accountItemList[i],
            ),
          );
        }

        PBottomSheet.show(
          context,
          title: L10n.tr('hesap'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: accountListWidget,
          ),
        );
      },
      child: Row(
        children: [
          Text(
            _selectedAccount,
            style: context.pAppStyle.labelMed14primary,
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          SvgPicture.asset(
            ImagesPath.chevron_down,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
            width: 15,
            height: 15,
          )
        ],
      ),
    );
  }
}
