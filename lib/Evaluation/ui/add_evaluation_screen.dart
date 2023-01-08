// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:u_calc/Evaluation/model/evaluation.dart';

import 'package:u_calc/widgets/myWidgets.dart';

class AddEvaluationScreen extends StatefulWidget {
  const AddEvaluationScreen({super.key});

  @override
  State<AddEvaluationScreen> createState() => _AddEvaluationScreenState();
}

class _AddEvaluationScreenState extends State<AddEvaluationScreen> {
  final _formKey = GlobalKey<FormState>();

  final evaluationNameController = TextEditingController();
  final evaluationWeigthController = TextEditingController();
  final evaluationScoreController = TextEditingController();

  @override
  void dispose() {
    evaluationNameController.dispose();
    evaluationWeigthController.dispose();
    evaluationScoreController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final evaluationName = evaluationNameController.text.trim();
      final evaluationWeigth =
          double.parse(evaluationWeigthController.text.trim());
      final evaluationScore =
          double.parse(evaluationScoreController.text.trim());
      if (evaluationName.isEmpty || evaluationWeigth.toString().isEmpty) {
        return;
      }

      Evaluation evaluation = Evaluation(
          name: evaluationName,
          weight: evaluationWeigth,
          score: evaluationScore);

      Navigator.of(context).pop(evaluation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: AlertDialog(
        //contentPadding: EdgeInsets.symmetric(horizontal: 5),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _evaluationTitle(),
                _evaluationData(),
                _buttons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _evaluationTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Text("Añadir Evaluación"),
    );
  }

  Widget _evaluationData() {
    return Column(
      children: [
        //! Nombre
        MyTextFormField(
          label: "Nombre de evaluación",
          maxLength: 15,
          controller: evaluationNameController,
        ),
        //! Peso & Nota
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              //! Peso
              Expanded(
                child: MyScoreFormField(
                  label: "Peso (%)",
                  maxValue: 100,
                  controller: evaluationWeigthController,
                ),
              ),
              //! Espacio
              SizedBox(width: 15),
              //! Nota
              Expanded(
                child: MyScoreFormField(
                  label: "Nota",
                  maxValue: 20,
                  controller: evaluationScoreController,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cancelButton(),
        SizedBox(width: 15),
        saveButton(),
      ],
    );
  }

  Widget saveButton() {
    return ElevatedButton(
      onPressed: () {
        _onSave();
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Text(
          "Añadir",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget cancelButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Text(
          "Cancelar",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
