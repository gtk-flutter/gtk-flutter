import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';

/// Button that is usually placed inside an `AdwHeaderBar` widget.
///
/// Via the `icon` parameter, a widget can be placed inside the button.
class AdwHeaderButton extends StatelessWidget {
  /// The icon of the button. Default size would be `17`.
  final Widget icon;

  /// Controls the active status, generally used for popup buttons.
  final bool isActive;

  /// Triggered when the button is pressed.
  final VoidCallback? onPressed;

  const AdwHeaderButton({
    Key? key,
    required this.icon,
    this.isActive = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdwButton.flat(
      constraints: BoxConstraints.tight(const Size.square(34)),
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      isActive: isActive,
      child: IconTheme.merge(
        data: const IconThemeData(size: 17),
        child: icon,
      ),
    );
  }
}
