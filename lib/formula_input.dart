import 'package:flutter/material.dart';

class FormulaInputWidget extends StatefulWidget {
  final VoidCallback onApply;

  FormulaInputWidget(this.onApply);

  @override
  State<StatefulWidget> createState() => _FormulaInputState();
}

class _FormulaInputState extends State<FormulaInputWidget> {
  var _text = "";

  var _controller = TextEditingController.fromValue(TextEditingValue.empty);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _text = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller.value = _controller.value.copyWith(
        text: _text,
        selection: TextSelection(
            baseOffset: _text.length, extentOffset: _text.length));
    return Column(children: <Widget>[
      TextField(
        autocorrect: false,
        decoration:
        InputDecoration(hintText: "Al + HCl = AlCl3 + H2", isDense: true),
        controller: _controller,
        scrollPadding: EdgeInsets.zero,
        enableSuggestions: false,
        onEditingComplete: widget.onApply,
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _text += "=";
                    });
                  },
                  child: Text(
                    "=",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 18.0),
                  ))),
          Expanded(
              child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _text += "+";
                    });
                  },
                  child: Text(
                    "+",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 18.0),
                  )))
        ],
      )
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}