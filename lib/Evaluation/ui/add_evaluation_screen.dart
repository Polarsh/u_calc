// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:u_calc/Evaluation/model/evaluation.dart';

class AddEvaluationScreen extends StatefulWidget {
  const AddEvaluationScreen({super.key});

  @override
  State<AddEvaluationScreen> createState() => _AddEvaluationScreenState();
}

class _AddEvaluationScreenState extends State<AddEvaluationScreen> {
  final evaluationNameController = TextEditingController();
  final evaluationWeigthController = TextEditingController();

  void _onSave() {
    final evaluationName = evaluationNameController.text.trim();
    final evaluationWeigth = int.parse(evaluationWeigthController.text.trim());

    if (evaluationName.isEmpty || evaluationWeigth.toString().isEmpty) {
      return;
    }

    Evaluation evaluation =
        Evaluation(name: evaluationName, weight: evaluationWeigth, score: 0);

    Navigator.of(context).pop(evaluation);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Center(child: Text("Ingrese nombre de evaluacion")),
                Padding(
                  padding: EdgeInsets.zero,
                  //EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
                  child: TextField(
                    controller: evaluationNameController,
                    textAlign: TextAlign.center,
                    //inputFormatters: <TextInputFormatter>[
                    //  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    //],
                    decoration: InputDecoration(
                      hintText: "Nombre de evaluacion",
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Center(child: Text("Ingrese peso (%)")),
                Padding(
                  padding: EdgeInsets.zero,
                  //EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
                  child: TextField(
                    controller: evaluationWeigthController,
                    maxLength: 2,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    decoration:
                        InputDecoration(hintText: "Peso en %", counterText: ''),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _onSave();
              },
              child: Text("Guardar evaluacion"),
            )
          ],
        ),
      ),
    );
  }
}
