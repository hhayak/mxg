import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:reactive_forms/reactive_forms.dart';

class WeightField extends StatefulWidget {
  final FormControl<int> control;

  const WeightField({Key? key, required this.control}) : super(key: key);

  @override
  _WeightFieldState createState() => _WeightFieldState();
}

class _WeightFieldState extends State<WeightField> {
  late int weight;

  void updateWeight(int newValue) {
    setState(() {
      weight = newValue;
      widget.control.updateValue(newValue);
    });
  }

  @override
  void initState() {
    weight = 60;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WeightSlider(
      height: 80,
      weight: weight,
      minWeight: 40,
      maxWeight: 120,
      onChange: updateWeight,
    );
  }
}

class WeightSlider extends StatelessWidget {
  final int weight;
  final int minWeight;
  final int maxWeight;
  final String unit;
  final double height;
  final double? width;
  final ValueChanged<int> onChange;

  const WeightSlider(
      {Key? key,
      this.weight = 80,
      this.minWeight = 30,
      this.maxWeight = 130,
      this.unit = '',
      this.height = 100,
      this.width,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeightBackground(
      height: height,
      width: width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.isTight
              ? Container()
              : WeightSliderInternal(
                  minValue: minWeight,
                  maxValue: maxWeight,
                  value: weight,
                  unit: unit,
                  onChange: onChange,
                  width: constraints.maxWidth,
                );
        },
      ),
    );
  }
}

class WeightBackground extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final String? unit;

  const WeightBackground(
      {Key? key, this.child, this.height = 100, this.width, this.unit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        //alignment: Alignment.bottomCenter,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: height,
              //width: width,
              child: child,
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Icon(Icons.keyboard_arrow_up)),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              unit ?? 'KG',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class WeightSliderInternal extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final int value;
  final String unit;
  final ValueChanged<int> onChange;
  final double width;
  final ScrollController scrollController;

  WeightSliderInternal({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.unit,
    required this.onChange,
    required this.width,
  })  : scrollController = ScrollController(
          initialScrollOffset: (value - minValue) * width / 3,
        ),
        super(key: key);

  double get itemExtent => width / 3;

  int _indexToValue(int index) => minValue + (index - 1);

  @override
  build(BuildContext context) {
    int itemCount = (maxValue - minValue) + 3;
    return NotificationListener(
      onNotification: _onNotification,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemExtent: itemExtent,
        itemCount: itemCount,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          int itemValue = _indexToValue(index);
          bool isExtra = index == 0 || index == itemCount - 1;

          return isExtra
              ? Container()
              : GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _animateTo(itemValue, durationMillis: 50),
                  child: FittedBox(
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 200),
                      style: _getTextStyle(context, itemValue),
                      child: Text(
                        itemValue != value
                            ? itemValue.toString()
                            : itemValue.toString() + unit,
                        //style: _getTextStyle(context, itemValue),
                      ),
                    ),
                    fit: BoxFit.scaleDown,
                  ),
                );
        },
      ),
    );
  }

  TextStyle _getDefaultTextStyle() {
    return TextStyle(
      //color: Color.fromRGBO(196, 197, 203, 1.0),
      fontSize: 14.0,
    );
  }

  TextStyle _getHighlightTextStyle(BuildContext context) {
    return TextStyle(
      //color: Theme.of(context).primaryColor,
      fontSize: 28.0,
    );
  }

  TextStyle _getTextStyle(BuildContext context, int itemValue) {
    return itemValue == value
        ? _getHighlightTextStyle(context)
        : _getDefaultTextStyle();
  }

  bool _userStoppedScrolling(Notification notification) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  _animateTo(int valueToSelect, {int durationMillis = 200}) {
    double targetExtent = (valueToSelect - minValue) * itemExtent;
    scrollController.animateTo(
      targetExtent,
      duration: Duration(milliseconds: durationMillis),
      curve: Curves.decelerate,
    );
  }

  int _offsetToMiddleIndex(double offset) => (offset + width / 2) ~/ itemExtent;

  int _offsetToMiddleValue(double offset) {
    int indexOfMiddleElement = _offsetToMiddleIndex(offset);
    int middleValue = _indexToValue(indexOfMiddleElement);
    middleValue = math.max(minValue, math.min(maxValue, middleValue));

    return middleValue;
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      int middleValue = _offsetToMiddleValue(notification.metrics.pixels);
      if (_userStoppedScrolling(notification)) {
        _animateTo(middleValue);
      }

      if (middleValue != value && onChange != null) {
        onChange(middleValue);
      }
    }

    return true;
  }
}
