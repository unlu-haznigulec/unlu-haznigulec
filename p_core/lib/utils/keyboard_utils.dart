import 'package:design_system/components/keyboard_actions/numeric_keyboard.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/utils/platform_utils.dart';

final ValueNotifier<bool> isCustomKeyboardOpen = ValueNotifier(false);

class KeyboardUtils {
  static void dismissKeyboard() {
    if (PlatformUtils.isMobile) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /// Cusom keyboard acilan yerlerrde bottom padding verir
  static Widget customViewInsetsBottom() {
    return ValueListenableBuilder<bool>(
      valueListenable: isCustomKeyboardOpen,
      builder: (context, isOpen, child) {
        return SizedBox(
          height: isOpen ? kKeyboardHeight + Grid.xl : 0,
        );
      },
    );
  }

  void scrollOnFocus(
    BuildContext context,
    GlobalKey key,
    ScrollController scrollController,
  ) {
    final RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final double y = position.dy + box.size.height;
    final double scrollPosition = scrollController.position.pixels;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    if (y > screenHeight - kKeyboardHeight - 10) {
      scrollController.animateTo(
        scrollPosition + y - kKeyboardHeight,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
