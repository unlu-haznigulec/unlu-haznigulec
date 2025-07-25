enum ThemeEnum {
  light('light', 'light_theme'),
  dark('dark', 'dark_theme'),
  deviceSettings('device', 'device_settings');

  final String value;
  final String localizationKey;
  const ThemeEnum(this.value, this.localizationKey);
}
