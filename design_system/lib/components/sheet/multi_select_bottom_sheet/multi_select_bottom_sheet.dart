import 'package:collection/collection.dart' show IterableExtension;
import 'package:design_system/components/button/button.dart';
import 'package:design_system/components/list/list_item.dart';
import 'package:design_system/components/list/selection_list_item.dart';
import 'package:design_system/components/progress_indicator/progress_indicator.dart';
import 'package:design_system/components/sheet/p_bottom_sheet.dart';
import 'package:design_system/extension/theme_context_extension.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:design_system/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:p_core/common/callback.dart';
import 'package:p_core/utils/debounce.dart';

typedef CustomModalBuilder<T> = Widget Function({
  required List<MultiSelectItem<T>> items,
  required List<MultiSelectItem<T>> selectedItems,
  required Function(List<MultiSelectItem<T>>) onChanged,
  String? title,
  required bool searchable,
  required bool isSingleSelection,
  required MultiSelectSearchSettings searchSettings,
  required bool moveSelectedToTop,
  String? hintText,
  required MultiSelectSheetItemType itemType,
  required MultiSelectSheetFieldType fieldType,
  MultiSelectSheetPaginationArgs? paginationArgs,
  MultiSelectAction<T>? positiveAction,
  MultiSelectAction<T>? negativeAction,
  required bool autoSave,
  String? emptyText,
  MultiSelectItem<T>? selectAllItem,
  bool? allowItemTextOverflow,
});

class MultiSelectItem<T> {
  final T value;
  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? titleIcon;
  final Widget? trailingWidget;

  const MultiSelectItem({
    required this.value,
    required this.title,
    this.subtitle,
    this.icon,
    this.titleIcon,
    this.trailingWidget,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MultiSelectItem && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class MultiSelectSearchSettings {
  final bool searchInValue;
  final bool searchInTitle;
  final bool searchInSubtitle;
  final ValueChanged<String>? searchDelegate;

  const MultiSelectSearchSettings.auto({
    this.searchInValue = false,
    this.searchInTitle = true,
    this.searchInSubtitle = false,
  }) : searchDelegate = null;

  const MultiSelectSearchSettings.delegated({
    required ValueChanged<String> this.searchDelegate,
  })  : searchInValue = false,
        searchInTitle = false,
        searchInSubtitle = false;
}

class MultiSelectSheetPaginationArgs {
  /// The pagination object parameters.
  final bool hasMore;
  final int offset;
  final int limit;

  /// The callback that is called when the user scrolls to the bottom of the list. Returns limit and offset integer
  /// Returning Pagination would be easier, but we cannot depend on it from this package right now
  final PDoubleParamCallback<int, int> onLoadMore;

  /// Whether the list is loading more items or not.
  final bool loadingMore;

  /// The error text that is shown when the list is loading for the first time.
  final String? initializationError;

  /// The error text that is shown when the list is loading more items.
  final String? loadingMoreError;

  const MultiSelectSheetPaginationArgs({
    required this.hasMore,
    required this.offset,
    required this.limit,
    required this.onLoadMore,
    this.loadingMore = false,
    this.initializationError,
    this.loadingMoreError,
  });
}

enum MultiSelectSheetItemType { checkbox, radio, plain }

enum MultiSelectSheetFieldType { inputChip, regular }

class MultiSelectAction<T> {
  /// The text of the action.
  final String? text;

  /// The action callback.
  final PCallback<List<T>>? action;

  MultiSelectAction({required this.text, required this.action});
}

class PMultiSelectField<T> extends StatelessWidget {
  /// The title of the field.
  final String title;

  /// The list of items to select from.
  final List<MultiSelectItem<T>> items;

  /// The list of items that are selected.
  final List<MultiSelectItem<T>> selectedItems;

  /// Whether the field is searchable or not.
  final bool searchable;

  /// Whether the selected items should be moved to the top of the list.
  final bool moveSelectedToTop;

  /// Whether the field should allow only one selection.
  final bool isSingleSelection;

  /// Whether the field is enabled or not.
  final bool enabled;

  /// Whether the field should auto save the selected items or not.
  final bool autoSave;

  /// The search settings for the field. Can be [auto] or [delegated].
  final MultiSelectSearchSettings searchSettings;

  /// The icon of the field.
  final IconData? icon;

  /// The callback that is called when the items are saved.
  final void Function(List<T> selection)? onSaved;

  /// The search hint text.
  final String? searchHintText;

  /// The hint text.
  final String? hintText;

  /// The error text.
  final String? errorText;

  /// The focus node of the field.
  final FocusNode? focusNode;

  /// The type of the item. Can be [checkbox], [radio] or [plain].
  final MultiSelectSheetItemType itemType;

  /// The type of the field. Can be [inputChip] or [regular].
  final MultiSelectSheetFieldType fieldType;

  /// The pagination arguments.
  final MultiSelectSheetPaginationArgs? paginationArgs;

  /// For building custom modals instead of default modal.
  final CustomModalBuilder<T>? customModalBuilder;

  /// The positive and negative actions.
  final MultiSelectAction<T>? positiveAction, negativeAction;

  /// The text that is shown when the list is empty.
  final String? emptyText;

  /// If provided, clicking on this item will select/deselect all the items. Note: this item should be add in [items] list as well.
  final MultiSelectItem<T>? selectAllItem;

  /// By default the items text are single line both for [checkbox], [radio] and [plain] itemType, if [allowItemTextOverflow] is true
  /// the item text will overflow (be in multiple line) if it's a long text.
  final bool allowItemTextOverflow;

  const PMultiSelectField({
    Key? key,
    required this.title,
    this.items = const [],
    this.selectedItems = const [],
    this.searchable = true,
    this.moveSelectedToTop = false,
    this.isSingleSelection = false,
    this.enabled = true,
    this.autoSave = true,
    this.searchSettings = const MultiSelectSearchSettings.auto(),
    this.icon,
    this.onSaved,
    this.searchHintText,
    this.hintText,
    this.errorText,
    this.focusNode,
    this.itemType = MultiSelectSheetItemType.checkbox,
    this.fieldType = MultiSelectSheetFieldType.inputChip,
    this.paginationArgs,
    this.customModalBuilder,
    this.positiveAction,
    this.negativeAction,
    this.emptyText,
    this.selectAllItem,
    this.allowItemTextOverflow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => enabled ? _showBottomSheet(context) : null,
          focusNode: focusNode,
          child: SizedBox(
            width: double.infinity,
            child: InputDecorator(
              decoration: context.pAppStyle.formFieldDecoration.copyWith(
                fillColor: enabled ? context.pColorScheme.lightHigh : context.pColorScheme.iconPrimary.shade100,
                enabled: enabled,
                errorText: errorText,
              ),
              isFocused: focusNode?.hasFocus == true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (fieldType == MultiSelectSheetFieldType.inputChip)
                    Text(
                      title,
                      style: context.pAppStyle.interRegularBase.copyWith(
                        fontSize: Grid.s + Grid.xs + Grid.xxs,
                        height: lineHeight150,
                        color: context.pColorScheme.darkMedium,
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: context.pAppStyle.interRegularBase.copyWith(
                            color: context.pColorScheme.darkMedium,
                            height: lineHeight125,
                          ),
                        ),
                        if (selectedItems.isEmpty)
                          Text(
                            hintText ?? '',
                            style: context.pAppStyle.interRegularBase.copyWith(
                              fontSize: Grid.m,
                              color: context.pColorScheme.darkLow,
                              height: lineHeight150,
                            ),
                          )
                        else
                          Text(
                            selectedItems.first.title,
                            style: context.pAppStyle.interRegularBase.copyWith(
                              fontSize: Grid.m,
                              color: context.pColorScheme.darkHigh,
                              height: lineHeight150,
                            ),
                          ),
                      ],
                    ),
                  Icon(
                    icon ?? Icons.keyboard_arrow_down,
                    color: context.pColorScheme.darkLow,
                    size: Grid.l,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (fieldType == MultiSelectSheetFieldType.inputChip)
          Padding(
            padding: const EdgeInsets.only(top: Grid.s),
            child: InputChipList(
              items: selectedItems,
              onDeleted: _onChipDeleted,
            ),
          ),
      ],
    );
  }

  void _onSelectionApplied() {
    onSaved?.call(selectedItems.map((it) => it.value).toList());
  }

  void _onChipDeleted(MultiSelectItem<T> item) {
    selectedItems.remove(item);
    onSaved?.call(selectedItems.map((it) => it.value).toList());
  }

  void _onSelectionChanged(List<MultiSelectItem<T>> selection) {
    selectedItems.clear();
    selectedItems.addAll(selection);
  }

  Future<void> _showBottomSheet(
    BuildContext context,
  ) async {
    await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.pColorScheme.backgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(Grid.m))),
      builder: (_) => customModalBuilder == null
          ? MultiSelectSheet<T>(
              items: items,
              selectedItems: selectedItems,
              title: title,
              searchable: searchable,
              autoSave: autoSave,
              moveSelectedToTop: moveSelectedToTop,
              hintText: searchHintText,
              isSingleSelection: isSingleSelection,
              onChanged: _onSelectionChanged,
              itemType: itemType,
              fieldType: fieldType,
              searchSettings: searchSettings,
              paginationArgs: paginationArgs,
              positiveAction: positiveAction,
              negativeAction: negativeAction,
              emptyText: emptyText,
              selectAllItem: selectAllItem,
              allowItemTextOverflow: allowItemTextOverflow,
            )
          : customModalBuilder!(
              items: items,
              selectedItems: selectedItems,
              title: title,
              searchable: searchable,
              autoSave: autoSave,
              moveSelectedToTop: moveSelectedToTop,
              hintText: searchHintText,
              isSingleSelection: isSingleSelection,
              onChanged: _onSelectionChanged,
              itemType: itemType,
              fieldType: fieldType,
              searchSettings: searchSettings,
              paginationArgs: paginationArgs,
              positiveAction: positiveAction,
              negativeAction: negativeAction,
              emptyText: emptyText,
              selectAllItem: selectAllItem,
              allowItemTextOverflow: allowItemTextOverflow,
            ),
    );
    if (autoSave) {
      _onSelectionApplied();
    }
  }
}

class MultiSelectSheet<T> extends StatefulWidget {
  /// The list of items to display.
  final List<MultiSelectItem<T>> items;

  /// The list of selected items.
  final List<MultiSelectItem<T>> selectedItems;

  /// The callback that is called when the selection changes.
  final void Function(List<MultiSelectItem<T>>) onChanged;

  /// The title of the bottom sheet.
  final String? title;

  /// Whether the bottom sheet is searchable.
  final bool searchable;

  /// Whether the selection should be saved automatically.
  final bool autoSave;

  /// Whether the selection is single or multiple.
  final bool isSingleSelection;

  /// The search settings.
  final MultiSelectSearchSettings searchSettings;

  /// Whether the selected items should be moved to the top.
  final bool moveSelectedToTop;

  /// The hint text for the search field.
  final String? hintText;

  /// The type of the item.
  final MultiSelectSheetItemType itemType;

  /// The type of the field.
  final MultiSelectSheetFieldType fieldType;

  /// The pagination arguments.
  final MultiSelectSheetPaginationArgs? paginationArgs;

  /// The positive and negative actions.
  final MultiSelectAction<T>? positiveAction, negativeAction;

  /// The text to display when the list is empty.
  final String? emptyText;

  /// Whether the list is loading.
  final bool loading;

  /// If provided, clicking on this item will select/deselect all the items. Note: this item should be add in [items] list as well.
  final MultiSelectItem<T>? selectAllItem;

  /// By default the items text are single line both for [checkbox], [radio] and [plain] itemType, if [allowItemTextOverflow] is true
  /// the item text will overflow (be in multiple line) if it's a long text.
  final bool? allowItemTextOverflow;

  const MultiSelectSheet({
    Key? key,
    required this.items,
    required this.onChanged,
    this.selectedItems = const [],
    this.title,
    this.searchable = false,
    this.autoSave = true,
    this.isSingleSelection = false,
    this.searchSettings = const MultiSelectSearchSettings.auto(),
    this.moveSelectedToTop = false,
    this.hintText,
    this.itemType = MultiSelectSheetItemType.checkbox,
    this.fieldType = MultiSelectSheetFieldType.inputChip,
    this.paginationArgs,
    this.positiveAction,
    this.negativeAction,
    this.emptyText,
    this.loading = false,
    this.selectAllItem,
    this.allowItemTextOverflow = false,
  }) : super(key: key);

  @override
  State<MultiSelectSheet<T>> createState() => _MultiSelectSheetState<T>();
}

class _MultiSelectSheetState<T> extends State<MultiSelectSheet<T>> with AutomaticKeepAliveClientMixin {
  static const maxSize = 0.93;
  static const minSizeWithKeyboard = 0.7;
  static const minSize = 0.25;

  late final List<MultiSelectItem<T>> selectedItems;
  final List<MultiSelectItem<T>> items = [];
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool keyboardOn = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectAllItem != null && widget.selectedItems.contains(widget.selectAllItem)) {
      selectedItems = [...widget.items];
    } else {
      selectedItems = [...widget.selectedItems];
    }

    if (widget.moveSelectedToTop) {
      _sortByOriginalOrder(selectedItems);
      _sortItems();
    } else {
      items.addAll(widget.items);
    }
    if (widget.searchable) {
      focusNode.addListener(_onSearchFocusChanged);
    }
  }

  @override
  void didUpdateWidget(covariant MultiSelectSheet<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    items
      ..clear()
      ..addAll(widget.items);
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      maintainBottomViewPadding: true,
      child: DraggableScrollableSheet(
        maxChildSize: maxSize,
        initialChildSize: keyboardOn ? maxSize : minSizeWithKeyboard,
        minChildSize: widget.searchable
            ? keyboardOn
                ? maxSize
                : minSizeWithKeyboard
            : minSize,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Grid.s),
            const Center(
              child: PBottomSheetGreyHeader(),
            ),
            const SizedBox(height: Grid.m),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: Grid.m, end: Grid.m),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title ?? '',
                    style: context.pAppStyle.interRegularBase.copyWith(
                      color: context.pColorScheme.iconPrimary.shade900,
                    ),
                  ),
                  const SizedBox(width: Grid.xl),
                  InkWell(
                    child: Icon(
                      Icons.close,
                      color: context.pColorScheme.darkHigh,
                      size: 24.0,
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            if (widget.searchable)
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: Grid.m,
                  end: Grid.m,
                  top: 12.0,
                ),
                child: SearchField(
                  controller: searchController,
                  onChanged: _onSearch,
                  hintText: widget.hintText,
                  focusNode: focusNode,
                ),
              ),
            const SizedBox(height: 12.0),
            if (_showEmptyView())
              Text(
                widget.emptyText!,
                textAlign: TextAlign.center,
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m,
                  color: context.pColorScheme.darkMedium,
                  height: lineHeight150,
                ),
              )
            else ...[
              Flexible(
                child: widget.paginationArgs == null
                    ? widget.loading
                        ? const Center(child: PCircularProgressIndicator())
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            controller: scrollController,
                            itemCount: items.length,
                            itemBuilder: (_, index) => _buildListItems(index),
                          )
                    : widget.loading && !widget.paginationArgs!.loadingMore
                        ? const Center(child: PCircularProgressIndicator())
                        : NotificationListener<ScrollNotification>(
                            onNotification: _onScroll,
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              controller: scrollController,
                              itemCount: items.length + 1,
                              itemBuilder: (_, index) => _buildListItemsPaginated(index),
                            ),
                          ),
              ),
              if (widget.positiveAction != null || widget.negativeAction != null) ...[
                Divider(
                  height: 0,
                  thickness: 0.75,
                  color: context.pColorScheme.stroke.shade200,
                  endIndent: Grid.m,
                  indent: Grid.m,
                ),
                Padding(
                  padding: const EdgeInsets.all(Grid.m),
                  child: Row(
                    children: [
                      if (widget.negativeAction != null)
                        Expanded(
                          child: POutlinedButton(
                            text: widget.negativeAction?.text ?? '',
                            onPressed: () =>
                                widget.negativeAction?.action?.call(selectedItems.map((it) => it.value).toList()),
                          ),
                        ),
                      if (widget.positiveAction != null && widget.negativeAction != null)
                        const SizedBox(
                          width: Grid.s,
                        ),
                      if (widget.positiveAction != null)
                        Expanded(
                          child: PButton(
                            text: widget.positiveAction?.text ?? '',
                            onPressed: selectedItems.isEmpty
                                ? null
                                : () =>
                                    widget.positiveAction?.action?.call(selectedItems.map((it) => it.value).toList()),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  void _onSearchFocusChanged() {
    if (keyboardOn && !focusNode.hasFocus) {
      setState(() => keyboardOn = false);
    } else if (!keyboardOn && focusNode.hasFocus) {
      setState(() => keyboardOn = true);
    }
  }

  bool _showEmptyView() {
    if (widget.paginationArgs != null) {
      return widget.emptyText != null &&
          widget.items.isEmpty &&
          !widget.loading &&
          widget.paginationArgs?.loadingMore == false;
    } else {
      return widget.emptyText != null && widget.items.isEmpty && !widget.loading;
    }
  }

  @override
  bool get wantKeepAlive => true;

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.extentAfter >= 0.0 &&
        widget.paginationArgs?.loadingMore == false &&
        widget.paginationArgs?.hasMore == true) {
      widget.paginationArgs!.onLoadMore.call(
        widget.paginationArgs!.limit,
        widget.paginationArgs!.offset + widget.paginationArgs!.limit,
      );
    }
    return false;
  }

  Widget _buildListItemsPaginated(int index) {
    if (index == items.length) {
      return widget.paginationArgs?.hasMore == true ? const PCircularProgressIndicator() : const SizedBox.shrink();
    } else {
      return _buildListItems(index);
    }
  }

  Widget _buildListItems(int index) {
    final item = items[index];
    final isSelected = selectedItems.contains(item);
    switch (widget.itemType) {
      case MultiSelectSheetItemType.checkbox:
        return PCheckboxListItem.trailingCheckBox(
          value: isSelected,
          title: item.title,
          subtitle: item.subtitle,
          leading: item.icon,
          titleIcon: item.titleIcon,
          trailingWidget: item.trailingWidget,
          allowOverflow: widget.allowItemTextOverflow == true,
          onChanged: (value) {
            _onSelectionChanged(item, value!);
          },
        );
      case MultiSelectSheetItemType.radio:
        return PRadioButtonListItem<MultiSelectItem<T>?>.trailingRadio(
          value: item,
          groupValue: isSelected
              ? item
              : selectedItems.isNotEmpty
                  ? selectedItems.first
                  : null,
          title: item.title,
          subtitle: item.subtitle,
          leading: item.icon,
          titleIcon: item.titleIcon,
          trailingWidget: item.trailingWidget,
          allowOverflow: widget.allowItemTextOverflow == true,
          onChanged: (selectedItem) {
            _onSelectionChanged(item, selectedItem == item);
          },
        );
      case MultiSelectSheetItemType.plain:
        return PListItem(
          title: item.title,
          subtitle: item.subtitle,
          leading: item.icon,
          titleIcon: item.titleIcon,
          trailingWidget: item.trailingWidget,
          allowOverflow: widget.allowItemTextOverflow == true,
          onTap: () {
            Navigator.pop(context);
            widget.onChanged([item]);
          },
        );
    }
  }

  void _onSelectionChanged(MultiSelectItem<T> item, bool isSelected) {
    if (widget.isSingleSelection) {
      setState(() {
        if (isSelected) {
          selectedItems.clear();
          selectedItems.add(item);
        } else {
          selectedItems.clear();
        }
      });
    } else {
      if (isSelected) {
        setState(() {
          if (widget.selectAllItem != null &&
              (item == widget.selectAllItem || selectedItems.length == items.length - 2)) {
            // -2 because of the selectAllItem item and because the current [item] haven't been added yet.
            selectedItems.clear();
            selectedItems.addAll(widget.items);
          } else {
            selectedItems.add(item);
          }
          if (widget.moveSelectedToTop) {
            _sortByOriginalOrder(selectedItems);
            final searchedSelected = items.where((element) => selectedItems.contains(element)).toList();
            final nonSelected = items.whereNot((element) => searchedSelected.contains(element)).toList();
            _sortByOriginalOrder(nonSelected);
            items.clear();
            items.addAll([...searchedSelected, ...nonSelected]);
          }
        });
      } else {
        setState(() {
          if (widget.moveSelectedToTop) {
            if (items.length < widget.items.length) {
              selectedItems.remove(item);
              final searchedSelected = items.where((element) => selectedItems.contains(element)).toList();
              final nonSelected = items.whereNot((element) => searchedSelected.contains(element)).toList();
              _sortByOriginalOrder(nonSelected);
              items.clear();
              items.addAll([...searchedSelected, ...nonSelected]);
            } else {
              items.remove(item);
              items.insert(widget.items.indexOf(item) + selectedItems.length - selectedItems.indexOf(item) - 1, item);
              selectedItems.remove(item);
            }
          } else {
            if (widget.selectAllItem != null && item == widget.selectAllItem) {
              selectedItems.clear();
            } else {
              selectedItems.remove(item);
              if (widget.selectAllItem != null && selectedItems.contains(widget.selectAllItem)) {
                selectedItems.remove(widget.selectAllItem);
              }
            }
          }
        });
      }
    }
    if (widget.autoSave) {
      widget.onChanged(selectedItems);
    }
  }

  void _onSearch(String query) {
    if (widget.searchSettings.searchDelegate != null) {
      widget.searchSettings.searchDelegate?.call(query);
      return;
    }

    if (query.isEmpty) {
      if (widget.moveSelectedToTop) {
        setState(() {
          items.clear();
          items.addAll(selectedItems);
          items.addAll(widget.items.whereNot((it) => selectedItems.contains(it)));
        });
      } else {
        setState(() {
          items.clear();
          items.addAll(widget.items);
        });
      }
      return;
    }

    setState(() {
      _searchUpdateCurrentItems(query);
      if (widget.moveSelectedToTop) {
        _sortItems(isSearching: true);
      }
    });
  }

  void _searchUpdateCurrentItems(String query) {
    final searchQuery = query.toLowerCase();
    items.clear();
    final matchedItems = <MultiSelectItem<T>>{};
    if (widget.searchSettings.searchInValue && widget.items is List<MultiSelectItem<String?>>) {
      matchedItems
          .addAll(widget.items.where((it) => (it.value as String?)?.toLowerCase().contains(searchQuery) == true));
    }
    if (widget.searchSettings.searchInSubtitle) {
      matchedItems.addAll(widget.items.where((it) => it.subtitle?.toLowerCase().contains(searchQuery) == true));
    }
    if (widget.searchSettings.searchInTitle) {
      matchedItems.addAll(widget.items.where((it) => it.title.toLowerCase().contains(searchQuery)));
    }
    items.addAll(matchedItems);
  }

  void _sortItems({bool isSearching = false}) {
    if (isSearching) {
      final searched = [...items];
      final searchedSelected = searched.where((element) => selectedItems.contains(element));
      items.clear();
      items.addAll(searchedSelected);
      items.addAll(searched.whereNot((element) => searchedSelected.contains(element)));
    } else {
      items.clear();
      items.addAll(selectedItems);
      items.addAll(widget.items.whereNot((element) => selectedItems.contains(element)));
    }
  }

  void _sortByOriginalOrder(List<MultiSelectItem<T>> input) {
    input.sort(
      (MultiSelectItem<T> a, MultiSelectItem<T> b) => widget.items.indexOf(a).compareTo(widget.items.indexOf(b)),
    );
  }
}

class SearchField extends StatelessWidget {
  /// The controller that controls the text being edited.
  final TextEditingController controller;

  /// Called when the text being edited changes.
  final void Function(String text) onChanged;

  /// The text to display when the field is empty.
  final String? hintText;

  /// Whether the text field is enabled or not.
  final bool enabled;

  /// Whether the text field is loading or not.
  final bool loading;

  /// The focus node that controls the focus of the text field.
  final FocusNode? focusNode;

  const SearchField({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.hintText,
    this.enabled = true,
    this.loading = false,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      enabled: enabled,
      onChanged: (query) => debounce(const Duration(milliseconds: 300), onChanged, [query]),
      style: context.pAppStyle.interRegularBase.copyWith(
        fontSize: Grid.m,
        height: lineHeight150,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(Grid.s),
        prefixIcon: enabled ? const Icon(Icons.search) : null,
        suffixIcon: loading
            ? CircularProgressIndicator(color: context.pColorScheme.primary.shade500)
            : controller.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      controller.clear();
                      onChanged('');
                    },
                    child: const Icon(
                      Icons.cancel,
                      size: 20,
                    ),
                  )
                : null,
        fillColor: context.pColorScheme.iconPrimary.shade100,
        filled: true,
        hintText: hintText ?? '',
        hintStyle: context.pAppStyle.interRegularBase.copyWith(
          fontSize: Grid.m,
          color: context.pColorScheme.iconPrimary.shade500,
          height: lineHeight150,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: context.pColorScheme.lightHigh,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(Grid.m),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: context.pColorScheme.lightHigh,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(Grid.m),
          ),
        ),
      ),
    );
  }
}

class InputChipList<T> extends StatelessWidget {
  /// Called when a chip is deleted.
  final void Function(MultiSelectItem<T>) onDeleted;

  /// The list of items to display as chips.
  final List<MultiSelectItem<T>> items;

  const InputChipList({
    Key? key,
    required this.onDeleted,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Grid.s,
      children: items
          .mapIndexed(
            (index, item) => PInputChip(
              item: item,
              onDeleted: _onChipDeleted,
            ),
          )
          .toList(),
    );
  }

  void _onChipDeleted(MultiSelectItem<T> item) {
    onDeleted(item);
  }

  void updateSelection(List<MultiSelectItem<T>> newItems) {
    items.clear();
    items.addAll(newItems);
  }
}

// TODO(sezer): Move PInputChip to Design System
class PInputChip<T> extends StatelessWidget {
  /// The item to display as a chip.
  final MultiSelectItem<T> item;

  /// Called when the chip is deleted.
  final void Function(MultiSelectItem<T>)? onDeleted;

  const PInputChip({
    Key? key,
    required this.item,
    this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputChip(
      visualDensity: VisualDensity.compact,
      label: Text(
        item.title,
        style: context.pAppStyle.interRegularBase.copyWith(
          fontSize: Grid.s + Grid.xs + Grid.xxs,
          height: lineHeight150,
          color: context.pColorScheme.lightHigh,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      avatar: item.icon,
      backgroundColor: context.pColorScheme.iconPrimary.shade700,
      deleteIcon: Icon(
        Icons.cancel,
        color: context.pColorScheme.lightHigh,
        size: Grid.m,
      ),
      onDeleted: () => onDeleted?.call(item),
    );
  }
}
