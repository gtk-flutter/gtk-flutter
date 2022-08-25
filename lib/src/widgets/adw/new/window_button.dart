import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:libadwaita/src/utils/colors.dart';
import 'package:libadwaita/src/widgets/adw/new/windows_caption_button.dart';
import 'package:libadwaita/src/widgets/widgets.dart';

enum WindowButtonType { close, maximize, minimize }

class AdwWindowButton extends StatelessWidget {
  const AdwWindowButton({
    super.key,
    required this.buttonType,
    required this.onPressed,
    required this.nativeControls,
  });

  /// Executed when this button is pressed
  final VoidCallback? onPressed;

  /// The WindowButtonType for this window
  final WindowButtonType buttonType;

  final bool nativeControls;

  @override
  Widget build(BuildContext context) {
    return onPressed != null
        ? !nativeControls || Platform.isLinux
            ? AdwButton.circular(
                size: 24,
                margin: const EdgeInsets.all(6),
                onPressed: onPressed,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/${buttonType.name}.svg',
                    width: 16,
                    package: 'libadwaita',
                    height: 16,
                    color: context.textColor,
                  ),
                ),
              )
            : Platform.isWindows
                ? WindowCaptionButton(
                    onPressed: onPressed,
                    brightness: Theme.of(context).brightness,
                    type: buttonType,
                  )
                : Platform.isMacOS
                    ? const SizedBox()
                    : const SizedBox()
        : const SizedBox();
  }
}
