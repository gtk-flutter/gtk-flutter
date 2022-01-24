import 'package:flutter/material.dart';

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black12;
    final half = size.width / 2;
    final path = Path()
      ..moveTo(1, 12)
      ..lineTo(half - 10, 12)
      ..lineTo(half, 1)
      ..lineTo(half + 10, 12)
      ..lineTo(size.width - 1, 12);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class PopOverClipper extends CustomClipper<Path> {
  PopOverClipper();

  @override
  Path getClip(Size size) {
    final half = size.width / 2;
    final path = Path()
      ..moveTo(0, 15)
      ..lineTo(half - 10, 15)
      ..lineTo(half, 5)
      ..lineTo(half + 10, 15)
      ..lineTo(size.width, 15)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _PopoverRoute extends PopupRoute<dynamic> {
  _PopoverRoute({
    required this.body,
    required this.width,
    required this.height,
    required this.position,
    required this.contentOffset,
    required this.backgroundColor,
  });

  final Widget body;
  final double width;
  final double? height;
  final Offset position;
  final Offset contentOffset;
  final Color backgroundColor;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Popover Scrim';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Align(
      alignment: Alignment.topLeft,
      child: Transform.translate(
        offset: Offset(
          position.dx + contentOffset.dx,
          position.dy + contentOffset.dy,
        ),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: width, maxHeight: height ?? 200),
          child: ClipPath(
            clipper: PopOverClipper(),
            child: Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: BorderPainter(),
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: body,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 150);
}

Future showPopover({
  required BuildContext context,
  required Widget child,
  required double width,
  required Color backgroundColor,
  required Offset contentOffset,
  required double? height,
}) {
  final navigator = Navigator.of(context, rootNavigator: true);

  final renderObject = context.findRenderObject();
  final translation = renderObject?.getTransformTo(null).getTranslation();
  var position = Offset(translation!.x, translation.y);

  final rbox = renderObject! as RenderBox;
  final size = rbox.size;
  position += Offset(size.width / 2, size.height);
  position += Offset(-width / 2, 0);

  return navigator.push(
    _PopoverRoute(
      body: child,
      width: width,
      height: height,
      position: position,
      backgroundColor: backgroundColor,
      contentOffset: contentOffset,
    ),
  );
}
