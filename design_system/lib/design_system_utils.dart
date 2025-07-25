class DesignSystemUtils {
  static String getPackageAssetPath(String assetPath) {
    // TODO(selcukguvel): Get package name `design_system` dynamically
    return 'packages/design_system/$assetPath';
  }
}
