// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:u_calc/Course/model/course.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final courseNameController = TextEditingController();
  final courseWeigthController = TextEditingController();

  void _onSave() {
    final courseName = courseNameController.text.trim();
    final courseWeigth = int.parse(courseWeigthController.text.trim());

    if (courseName.isEmpty) {
      return;
    }

    Course course = Course(name: courseName, weigth: courseWeigth, score: 0);

    Navigator.of(context).pop(course);
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
                Center(child: Text("Ingrese nombre del curso")),
                Padding(
                  padding: EdgeInsets.zero,
                  //EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
                  child: TextField(
                    controller: courseNameController,
                    textAlign: TextAlign.center,
                    //inputFormatters: <TextInputFormatter>[
                    //  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    //],
                    decoration: InputDecoration(
                      hintText: "Nombre de curso",
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Center(child: Text("Ingrese peso del curso")),
                Padding(
                  padding: EdgeInsets.zero,
                  //EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
                  child: TextField(
                    controller: courseWeigthController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    decoration: InputDecoration(
                      hintText: "Peso de curso",
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _onSave();
              },
              child: Text("Guardar curso"),
            )
          ],
        ),
      ),
    );
  }
}
