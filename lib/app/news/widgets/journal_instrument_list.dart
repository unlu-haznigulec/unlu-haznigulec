import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/journal_symbol_card.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/news_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class JournalInstrumentList extends StatelessWidget {
  final News news;
  final MarketListModel? symbol;
  final double? maxWidth;

  const JournalInstrumentList({
    super.key,
    required this.news,
    this.symbol,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (news.symbol == null) return const SizedBox.shrink();
    List<dynamic> symbols = news.symbol!.where((element) => element != null).toSet().toList();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 23,
        maxWidth: maxWidth ?? MediaQuery.sizeOf(context).width * 0.45,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: symbols.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              getIt<SymbolBloc>().add(
                SymbolDetailPageEvent(
                  symbolData: MarketListModel(
                    symbolCode: symbols[index],
                    updateDate: DateTime.now().toString(),
                    type: SymbolTypes.equity.name,
                  ),
                ),
              );
            },
            child: JournalSymbolCard(
              symbolCode: symbols[index],
            ),
          );
        },
      ),
    );
  }
}
