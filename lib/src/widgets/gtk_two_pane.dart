import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gtk/src/utils/colors.dart';

class GtkTwoPane extends StatefulWidget {
  final Widget pane1;
  final Widget pane2;

  /// keeps track of the pane2 open state
  final bool showPane2;

  /// keeps track of the pane2 header name
  final String? pane2Name;

  /// Called called when pane2Popup
  final void Function() onClosePane2Popup;

  /// the breakpoint for small devices
  final double breakpoint;

  /// pane1 has a width of `panelWidth`
  ///
  /// pane2 `total - panelWidth`
  final double panelWidth;

  // Pane 2 builder on smaller screen
  final Function(String? pane2Name, Widget pane2)? fullPane2Builder;

  const GtkTwoPane({
    Key? key,
    this.showPane2 = false,
    required this.pane1,
    required this.pane2,
    required this.onClosePane2Popup,
    this.breakpoint = 800,
    this.panelWidth = 250,
    this.pane2Name,
    this.fullPane2Builder,
  }) : super(key: key);

  @override
  _GtkTwoPaneState createState() => _GtkTwoPaneState();
}

class _GtkTwoPaneState extends State<GtkTwoPane> {
  bool _popupNotOpen = true;

  bool get canSplitPanes =>
      widget.breakpoint < MediaQuery.of(context).size.width;

  /// Loads and removes the popup page for pane2 on small screens
  void loadPane2Page(BuildContext context) async {
    if (widget.showPane2 && _popupNotOpen) {
      _popupNotOpen = false;
      SchedulerBinding.instance!.addPostFrameCallback((_) async {
        // sets _popupNotOpen to true after popup is closed
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(
                body: widget.fullPane2Builder != null
                    ? widget.fullPane2Builder!(widget.pane2Name, widget.pane2)
                    : widget.pane2,
              );
            },
            fullscreenDialog: true,
          ),
        )
            .then((_) {
          // less code than wapping in a WillPopScope
          _popupNotOpen = true;
          // preserves value if screen canSplitPanes
          if (!canSplitPanes) widget.onClosePane2Popup();
        });
      });
    }
  }

  /// closes popup wind
  void _closePopup() {
    if (!_popupNotOpen) {
      SchedulerBinding.instance!
          .addPostFrameCallback((_) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (canSplitPanes && widget.showPane2) {
      _closePopup();
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                    width: 1,
                    color: Theme.of(context).brightness == Brightness.light
                        ? borderLight
                        : borderDark),
              ),
            ),
            width: widget.panelWidth,
            child: widget.pane1,
          ),
          Flexible(
            child: widget.pane2,
          ),
        ],
      );
    } else {
      loadPane2Page(context);
      return Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            flex: 100,
            child: widget.pane1,
          ),
        ],
      );
    }
  }
}
