import 'package:SimpleWindowCalculator/Tools/Format.dart';
import 'package:SimpleWindowCalculator/objects/Factor.dart';

import '../objects/OManager.dart';
import '../objects/Window.dart';
import 'package:flutter/material.dart';

class FactorCoin extends StatefulWidget {
  final double size;
  final Color backgroundColor;
  final Alignment alignment;
  final Factors factorKey;
  final Widget child; // TODO: Remove when redesign occurs
  final Window window;
  final Function updateTotal;

  static const double iconRatio = 1 / 6;

  FactorCoin({
    @required this.size,
    this.updateTotal,
    this.factorKey,
    this.window,
    this.child,
    this.backgroundColor = Colors.white,
    this.alignment = Alignment.center,
  });

  @override
  _FactorCoinState createState() {
    return _FactorCoinState();
  }
}

/*  STATE !!!
 *  --------------------------------------------------------------------
 *  FactorCoin, stateful widget because the border changes color
 *  indicated to the user whether they are incrmenting or decrementing. 
 *  --------------------------------------------------------------------
 */
class _FactorCoinState extends State<FactorCoin> {
  bool disabled = false;
  bool modeIncrement = true;

  _FactorCoinState();

// Makes the Factor count along with the window count
// ** Does not necessarily mean they have the same count
// ** Factor counting occurs inside the window object
  changeAttachmentStatus() {
    setState(() {
      // If disable is true then factor is affixed
      disabled ? disabled = false : disabled = true;
    });
    widget.window.affixFactor(widget.factorKey, disabled);
  }

// Changes mode from incrementing to decrementing and vice-versa
  changeMode() {
    setState(() {
      modeIncrement ? modeIncrement = false : modeIncrement = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Factor factor = widget.window != null
        ? widget.window.getFactor(widget.factorKey)
        : null;

    return Column(
      children: [
        Text(factor != null ? '${Format.format((factor.getCount()))}' : ''),
        disabled
            // (disabled) -> Coin is grayed out and has to be held to re-enable
            //  * while disabled cannot drag or increment/decrement
            ? InkWell(
                onLongPress: () {
                  changeAttachmentStatus();
                },
                child: mintCoin(context, true, widget.size),
              )
            // (!disabled) -> Coin is draggable and increments
            : Draggable<Function>(
                data: changeAttachmentStatus,
                feedback: mintCoin(context, false, widget.size * 1.5),
                childWhenDragging: mintCoin(context, true, widget.size),
                child: InkWell(
                  onTap: () {
                    modeIncrement
                        ? widget.window.incrementFactor(widget.factorKey)
                        : widget.window.decrementFactor(widget.factorKey);
                    widget.updateTotal();
                  },
                  onLongPress: () {
                    changeMode();
                  },
                  child: mintCoin(context, disabled, widget.size),
                ),
              ),
        Text(factor != null
            ? '\$${Format.format((factor.getUpdatedPrice(widget.window.getPrice())))}'
            : ''),
      ],
    );
  }

  /*
   *  Builds the coin aesthetics 
   */
  Card mintCoin(BuildContext context, bool greyed, double coinSize) {
    return Card(
      color: greyed ? Colors.grey : widget.backgroundColor,
      shape: CircleBorder(
        side: BorderSide(
          color: styleBorder(context, greyed),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: greyed
          ? ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              child: _buildIMGContainer(coinSize),
            )
          : _buildIMGContainer(coinSize),
    );
  }

  /*
   *  Builds the inner image of the coin, needed as a method because
   *  when attached or dragged the entire image is grey-scaled.
   *  ** IconImage and container holder
   */
  Container _buildIMGContainer(double coinSize) {
    return Container(
      height: coinSize,
      width: coinSize,
      padding: EdgeInsets.all(coinSize * FactorCoin.iconRatio),
      alignment: widget.alignment,
      // Takes the factor image. Otherwise takes any widget child and builds the circle
      // around it. Used for Window Specific Counter.
      child: widget.window != null
          ? widget.window.getFactor(widget.factorKey).getImage()
          : widget.child,
    );
  }

  /*
   * Used for immutable circles
   *  ** TODO: Remove when design occurs.
   */
  Color styleBorder(BuildContext ctx, bool gray) {
    if (widget.child != null) {
      return Theme.of(ctx).primaryColor;
    } else {
      return disabled || gray
          ? Colors.blueGrey
          : (modeIncrement ? Colors.green : Colors.red);
    }
  }
}
