// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyScoreFormField extends StatefulWidget {
  final String label;
  final int maxValue;
  final TextEditingController controller;
  const MyScoreFormField(
      {super.key,
      required this.label,
      required this.maxValue,
      required this.controller});

  @override
  State<MyScoreFormField> createState() => _MyScoreFormField();
}

class _MyScoreFormField extends State<MyScoreFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.red),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.green),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.green),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        label: Text(
          widget.label,
          textAlign: TextAlign.left,
        ),
        counterText: '',
      ),
      cursorRadius: Radius.circular(10),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return "Ingrese ${widget.label}";
        }
        var numValue = double.parse(value);
        if (numValue < 0 || numValue > widget.maxValue) {
          return "No es válido";
        }
        return null;
      },
    );
  }
}
