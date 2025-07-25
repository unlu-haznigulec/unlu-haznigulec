import 'package:design_system/common/widgets/divider.dart';
import 'package:design_system/components/selection_control/checkbox.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_state.dart';
import 'package:piapiri_v2/app/favorite_lists/favorite_list_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/p_symbol_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolSearchTile extends StatefulWidget {
  final SymbolModel symbol;
  final void Function(SymbolModel symbol) onTapSymbol;
  final bool isSelected;
  final bool isCheckbox;

  const SymbolSearchTile({
    super.key,
    required this.symbol,
    required this.onTapSymbol,
    required this.isSelected,
    this.isCheckbox = false,
  });

  @override
  State<SymbolSearchTile> createState() => _SymbolSearchTileState();
}

class _SymbolSearchTileState extends State<SymbolSearchTile> {
  late SymbolTypes _symbolTypes;
  late AuthBloc _authBloc;
  late FavoriteListBloc _favoriteListBloc;

  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();
    _favoriteListBloc = getIt<FavoriteListBloc>();
    _symbolTypes = stringToSymbolType(widget.symbol.typeCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTapSymbol(widget.symbol),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.m + Grid.xs,
            ),
            child: PSymbolTile(
              variant: PSymbolVariant.search,
              title: widget.symbol.name,
              subTitle: '${widget.symbol.description} · ${L10n.tr(_symbolTypes.filter?.localization ?? '')}',
              symbolName: _symbolTypes == SymbolTypes.warrant ||
                      _symbolTypes == SymbolTypes.option ||
                      _symbolTypes == SymbolTypes.future ||
                      _symbolTypes == SymbolTypes.fund
                  ? widget.symbol.underlyingName
                  : widget.symbol.name,
              symbolType: _symbolTypes,
              trailingWidget: widget.isCheckbox
                  ? _authBloc.state.isLoggedIn
                      ? InkWell(
                          onTap: () => widget.onTapSymbol(widget.symbol),
                          child: IgnorePointer(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: PCheckbox(
                                value: widget.isSelected,
                                onChanged: (_) {},
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                  : _authBloc.state.isLoggedIn
                      ? _addFavouriteWidget()
                      : const SizedBox(),
            ),
          ),
          const PDivider()
        ],
      ),
    );
  }

  Widget _addFavouriteWidget() {
    return PBlocBuilder<FavoriteListBloc, FavoriteListState>(
      bloc: _favoriteListBloc,
      builder: (context, state) {
        bool isFavourite = FavoriteListUtils().isFavorite(widget.symbol.name, _symbolTypes);
        return InkWell(
          child: SvgPicture.asset(
            height: 24,
            width: 24,
            isFavourite ? ImagesPath.star_full : ImagesPath.star,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          onTap: () => FavoriteListUtils().toggleFavorite(
            context,
            widget.symbol.name,
            _symbolTypes,
          ),
        );
      },
    );
  }
}
