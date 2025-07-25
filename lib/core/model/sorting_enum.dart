enum SortingEnum {
  alphabetic('ALPHABETIC', 'a_to_z'),
  reverseAlphabetic('REVERSE_ALPHABETIC', 'z_to_a'),
  custom('CUSTOM', 'custom_sort');

  final String value;
  final String localization;
  const SortingEnum(
    this.value,
    this.localization,
  );
}
