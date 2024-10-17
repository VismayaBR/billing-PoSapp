import 'package:flutter/material.dart';

class CounterTextField extends StatefulWidget {
  final int initialCount;
  final TextEditingController controller;
  final void Function(int) onCounteClick;

  CounterTextField({Key? key, this.initialCount = 1, required this.controller, required this.onCounteClick})
      : super(key: key);

  @override
  _CounterTextFieldState createState() => _CounterTextFieldState();
}

class _CounterTextFieldState extends State<CounterTextField> {
  @override
  void initState() {
    super.initState();
    
    // Initialize the text field with the initial count
    widget.controller.text = widget.initialCount.toString();
  }

  void _updateCounter(int delta) {
    final currentCount = int.tryParse(widget.controller.text) ?? 0;
    final newCount = (currentCount + delta).clamp(0, double.infinity).toInt();
    widget.controller.text = newCount.toString();
    widget.onCounteClick(newCount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            iconSize: 25,
            icon: Icon(Icons.remove),
            onPressed: () {
              setState(() {
                _updateCounter(-1);
              });
            },
            color: Colors.green,
          ),
          Expanded(
            child: TextField(
              enabled: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              textAlign: TextAlign.center,
              controller: widget.controller,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          IconButton(
            iconSize: 25,
            icon: Icon(Icons.add),
            color: Colors.green,
            onPressed: () {
              setState(() {
                _updateCounter(1);
              });
            },
          ),
        ],
      ),
    );
  }
}
