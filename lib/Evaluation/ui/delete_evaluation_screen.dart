// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DeleteEvaluationScreen extends StatefulWidget {
  const DeleteEvaluationScreen({super.key});

  @override
  State<DeleteEvaluationScreen> createState() => _DeleteEvaluationScreenState();
}

class _DeleteEvaluationScreenState extends State<DeleteEvaluationScreen> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Eliminar evaluación"),
      content: Text("¿Está seguro de eliminar esta evaluación?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text("Si"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text("No"),
        )
      ],
    );
  }
}
