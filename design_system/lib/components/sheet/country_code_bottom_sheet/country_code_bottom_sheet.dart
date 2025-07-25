import 'package:country_flags/country_flags.dart';
import 'package:design_system/components/sheet/multi_select_bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/model/country_code.dart';

class CountryCodeBottomSheet extends StatelessWidget {
  final String? selectedCountryCode;
  final String? title;
  final String? hintText;
  final void Function(List<MultiSelectItem<CountryCode>>) onChanged;

  const CountryCodeBottomSheet({
    super.key,
    this.selectedCountryCode,
    required this.onChanged,
    this.title,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return MultiSelectSheet<CountryCode>(
      items: CountryCode.countryCodes.toMultiSelectItems,
      title: title,
      hintText: hintText,
      isSingleSelection: true,
      moveSelectedToTop: true,
      itemType: MultiSelectSheetItemType.plain,
      fieldType: MultiSelectSheetFieldType.regular,
      searchable: true,
      selectedItems: selectedCountryCode != null && CountryCode.isValidCountryCode(selectedCountryCode!)
          ? [
              _getSelectedCountryCode(selectedCountryCode!),
            ]
          : [],
      onChanged: onChanged,
    );
  }

  MultiSelectItem<CountryCode> _getSelectedCountryCode(String selectedItem) {
    final countryCode = CountryCode.getCountryCode(selectedItem)!;
    return MultiSelectItem(
      value: countryCode,
      title: '${countryCode.dialCode} ${countryCode.name}',
    );
  }
}

extension CountryCodeX on List<CountryCode> {
  List<MultiSelectItem<CountryCode>> get toMultiSelectItems => map(
        (country) => MultiSelectItem<CountryCode>(
          value: country,
          title: '${country.dialCode} ${country.name}',
          icon: CountryFlag.fromCountryCode(
            country.code,
            height: Grid.l,
            width: Grid.xl,
          ),
        ),
      ).toList();
}
