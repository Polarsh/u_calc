// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  final String label;
  final int maxLength;
  final TextEditingController controller;
  const MyTextFormField(
      {super.key,
      required this.label,
      required this.maxLength,
      required this.controller});

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  late var textLength = 0;

  @override
  void initState() {
    super.initState();
    textLength = widget.controller.text.length;
  }

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
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.blue),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        label: Text(
          widget.label,
          textAlign: TextAlign.left,
        ),
        suffixText: '${textLength.toString()}/${widget.maxLength.toString()}',
        counterText: '',
      ),
      cursorRadius: Radius.circular(10),
      keyboardType: TextInputType.text,
      autofocus: true,
      maxLength: widget.maxLength,
      onChanged: (value) {
        setState(() {
          textLength = value.length;
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Ingrese ${widget.label}";
        }
        return null;
      },
    );
  }
}
