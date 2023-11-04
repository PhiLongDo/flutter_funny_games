import 'package:flutter/material.dart';

class SizeSlider extends StatefulWidget {
  const SizeSlider(
      {super.key,
      required this.value,
      required this.onValueChanged,
      this.max = 1.0,
      this.min = 0.0});

  final double value;
  final Function(double) onValueChanged;
  final double max;
  final double min;

  @override
  State<SizeSlider> createState() => _SizeSliderState();
}

class _SizeSliderState extends State<SizeSlider> {
  late double _value;
  final _sizeSimple = 30.0;
  late double _sizeSimpleRatio;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _sizeSimpleRatio = _sizeSimple / (widget.max / widget.min);
  }

  void _onValueChange(double newValue) {
    widget.onValueChanged(newValue);
    setState(() {
      _value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          constraints:
              BoxConstraints(minHeight: _sizeSimple, minWidth: _sizeSimple),
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Container(
              width: _value,
              height: _value,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  border: Border.all(color: Colors.blueAccent)),
            ),
          ),
        ),
        Expanded(
          child: Slider(
              value: _value,
              onChanged: _onValueChange,
              min: widget.min,
              max: widget.max),
        ),
      ],
    );
  }
}
