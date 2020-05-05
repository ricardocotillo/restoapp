import 'package:flutter/material.dart';
import 'package:restaurante/models/Categoria.dart';

class MultipleChoice extends StatefulWidget {
  final String title;
  final List<Choice> choices;
  final bool isRadio;
  final Function(int, int) radioOnChange;
  final Function(int, bool) multipleOnChange;
  MultipleChoice(
      {this.title,
      @required this.choices,
      this.radioOnChange,
      this.multipleOnChange,
      this.isRadio = false});

  @override
  _MultipleChoiceState createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  int _groupValue = 0;
  List<Choice> _choices;

  @override
  void initState() {
    super.initState();
    _choices = widget.choices;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      child: Column(
          children: <Widget>[Text(widget.title?? '')] +
              List.generate(
                  _choices.length,
                  (int i) => widget.isRadio
                      ? RadioListTile(
                          title: Text(_choices[i].name),
                          dense: true,
                          secondary: _choices[i].price != null
                              ? Text('+' + _choices[i].price.toStringAsFixed(2))
                              : null,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: i,
                          groupValue: _groupValue,
                          onChanged: (int v) {
                            final int oldIndex = _groupValue;
                            setState(() {
                              _groupValue = v;
                            });
                            widget.radioOnChange(i, oldIndex);
                          })
                      : CheckboxListTile(
                          dense: true,
                          secondary: _choices[i].price != null
                              ? Text('+' + _choices[i].price.toStringAsFixed(2))
                              : null,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _choices[i].chosen,
                          title: Text(_choices[i].name),
                          onChanged: (v) {
                            setState(() {
                              _choices[i].chosen = v;
                            });
                            widget.multipleOnChange(i, v);
                          }))),
    );
  }
}
