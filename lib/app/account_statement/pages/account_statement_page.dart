import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/account_statement/pages/domestic_account_statement_page.dart';
import 'package:piapiri_v2/common/widgets/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class AccountStatementPage extends StatefulWidget {
  const AccountStatementPage({super.key});

  @override
  State<AccountStatementPage> createState() => _AccountStatementPageState();
}

class _AccountStatementPageState extends State<AccountStatementPage> {
  final int _selectedSegmentedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('account_summary'),
      ),
      body: Column(
        children: [
          /// Yurt Dışı kısmının backend'i hazır olmadığı için,
          /// yurt dışı tab'ının hiçbir şekilde gösterilmemesine karar verildi o yüzden yorum satırına alındı.

          // if (Utils().canTradeAmericanMarket()) ...[
          //   SizedBox(
          //   width: MediaQuery.sizeOf(context).width,
          //   height: 35,
          //   child: SlidingSegment(
          //     backgroundColor: PColor.card500,
          //     segmentList: [
          //       PSlidingSegmentItem(
          //         segmentTitle: L10n.tr('domestic'),
          //         segmentColor: PColor.primary100,
          //       ),
          //       PSlidingSegmentItem(
          //         segmentTitle: L10n.tr('abroad'),
          //         segmentColor: PColor.primary100,
          //       ),
          //     ],
          //     onValueChanged: (index) {
          //       setState(() {
          //         _selectedSegmentedIndex = index;
          //       });
          //     },
          //   ),
          // ),
          // const SizedBox(
          //   height: Grid.l,
          // ),
          // ],
          Expanded(
            child: _selectedSegmentedIndex == 0
                ? const DomesticAccountStatementPage()
                : const DomesticAccountStatementPage(),
          )
        ],
      ),
    );
  }
}
