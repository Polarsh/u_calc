// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:u_calc/Cycle/model/cycle.dart';

class AddCycleScreen extends StatefulWidget {
  const AddCycleScreen({super.key});

  @override
  State<AddCycleScreen> createState() => _AddCycleScreenState();
}

class _AddCycleScreenState extends State<AddCycleScreen> {
  final cycleNameController = TextEditingController();

  void _onSave() {
    final cyclename = cycleNameController.text.trim();

    if (cyclename.isEmpty) {
      return;
    }
    Cycle cycle = Cycle(name: cyclename, score: 0);

    Navigator.of(context).pop(cycle);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Text("Ingrese código del ciclo")),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.2),
              child: TextField(
                controller: cycleNameController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                decoration: InputDecoration(
                  hintText: "202202",
                  counterText: '',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _onSave();
              },
              child: Text("Guardar ciclo"),
            )
          ],
        ),
      ),
    );
  }
}
