import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';

class SymbolSelector extends StatelessWidget {
  final Function(SymbolModel) onTapSymbol;
  final SymbolModel? selectedSymbol;
  final Function()? onTapRemove;
  final ValueNotifier<int> pageIndexNotifier = ValueNotifier<int>(0);
  final int? watchlistItemType;
  final bool? viopExcept;
  final Color? color;

  SymbolSelector({
    super.key,
    required this.onTapSymbol,
    required this.selectedSymbol,
    this.onTapRemove,
    this.watchlistItemType = 1,
    this.viopExcept,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // WoltModalSheet.show<void>(
        //   maxPageHeight: .9,
        //   minPageHeight: .9,
        //   context: context,
        //   pageIndexNotifier: pageIndexNotifier,
        //   pageListBuilder: (modalSheetContext) {
        //     return [
        //       WoltModalSheetPage.withSingleChild(
        //         hasSabGradient: false,
        //         isTopBarLayerAlwaysVisible: true,
        //         topBarTitle: Text(
        //           L10n.tr('sembol_arama'),
        //           style: const TextStyle(
        //             color: Colors.white,
        //           ),
        //         ),
        //         trailingNavBarWidget: IconButton(
        //           padding: const EdgeInsets.all(
        //             Grid.s,
        //           ),
        //           icon: const Icon(
        //             Icons.close,
        //             color: context.pColorScheme.primary,
        //           ),
        //           onPressed: router.maybePop,
        //         ),
        //         child: SearchSymbol(
        //           watchlistItemType: watchlistItemType ?? 1,
        //           onTapSymbol: onTapSymbol,
        //           viopExcept: viopExcept ?? false,
        //         ),
        //       ),
        //     ];
        //   },
        //   onModalDismissedWithBarrierTap: () {
        //     router.maybePop();
        //   },
        // );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Grid.s),
        // child: SearchSymbolInput(
        //   backgroundColor: color  ?? context.pColorScheme.darkLow,
        //   text: selectedSymbol != null
        //       ? Text(
        //           selectedSymbol!.typeCode == SymbolTypes.warrant.name.toString() && selectedSymbol!.name.endsWith('V')
        //               ? selectedSymbol!.name.substring(0, selectedSymbol!.name.length - 1)
        //               : selectedSymbol!.name,
        //           style: const TextStyle(
        //             color: Colors.white,
        //             fontWeight: FontWeight.w600,
        //           ),
        //         )
        //       : const SizedBox(),
        //   onRemove: selectedSymbol != null && onTapRemove != null
        //       ? () {
        //           onTapRemove?.call();
        //         }
        //       : null,
        // ),
      ),
    );
  }
}
