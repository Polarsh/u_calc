// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:u_calc/Course/model/course.dart';
import 'package:u_calc/Evaluation/model/evaluation.dart';
import 'package:u_calc/Evaluation/ui/add_evaluation_screen.dart';
import 'package:u_calc/Evaluation/ui/delete_evaluation_screen.dart';
import 'package:u_calc/Evaluation/ui/edit_evaluation_screen.dart';
import 'package:u_calc/objectbox.g.dart';

class EvaluationsScreen extends StatefulWidget {
  final Course course;
  final Store store;
  const EvaluationsScreen(
      {super.key, required this.course, required this.store});

  @override
  State<EvaluationsScreen> createState() => _EvaluationsScreenState();
}

class _EvaluationsScreenState extends State<EvaluationsScreen> {
  List<String> headers = ["Evaluación", "Peso", "Nota", "Opciones"];
  List<Evaluation> evaluations = [];
  late double totalPercent;

  @override
  void initState() {
    evaluations.addAll(List.from(widget.course.evaluations));
    calculateCoursePercent();
    super.initState();
  }

  void calculateCourseScore() {
    late double score = 0;

    for (var evaluation in evaluations) {
      score += evaluation.score! * evaluation.weight * 0.01;
    }

    editCourseScore(score);

    setState(() {});
  }

  void calculateCoursePercent() {
    late double percent = 0;

    for (var evaluation in evaluations) {
      if (evaluation.score! > 0) {
        percent += evaluation.weight;
      }
    }

    setState(() {
      totalPercent = percent;
    });
  }

  Future<void> editCourseScore(double score) async {
    widget.course.score = score;
    widget.store.box<Course>().put(widget.course);
  }

  Future<void> addEvaluation() async {
    final result = await showDialog(
        context: context, builder: (_) => AddEvaluationScreen());

    if (result != null && result is Evaluation) {
      result.course.target = widget.course;
      widget.store.box<Evaluation>().put(result);
      _reloadEvaluations();
    }
  }

  Future<void> editEvaluation(Evaluation evaluation) async {
    final result = await showDialog(
        context: context,
        builder: (_) => EditEvaluationScreen(evaluation: evaluation));

    if (result != null && result is Evaluation) {
      evaluation.name = result.name;
      evaluation.weight = result.weight;
      evaluation.score = result.score;
      widget.store.box<Evaluation>().put(evaluation);
      _reloadEvaluations();
    }
  }

  Future<void> deleteEvaluation(Evaluation evaluation) async {
    final result = await showDialog(
        context: context, builder: (_) => DeleteEvaluationScreen());

    if (result) {
      widget.store.box<Evaluation>().remove(evaluation.id);
      _reloadEvaluations();
    }
  }

  void _reloadEvaluations() {
    evaluations.clear();

    QueryBuilder<Evaluation> builder = widget.store.box<Evaluation>().query();
    builder.link(Evaluation_.course, Course_.id.equals(widget.course.id));
    Query<Evaluation> query = builder.build();
    List<Evaluation> evaluationsResult = query.find();
    setState(() {
      evaluations.addAll(evaluationsResult);
    });
    query.close();
    calculateCourseScore();
    calculateCoursePercent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            myTitleCourse(),
            myAddButtons(),
            evaluations.isNotEmpty
                ? myDataTable()
                : Text("No hay evaluaciones, favor de añadirlas"),
          ],
        ),
      ),
    );
  }

  Widget myTitleCourse() {
    return Container(
      color: Colors.lightBlue.shade900,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Créditos: ${widget.course.weigth}"),
                widget.course.score > 12.5
                    ? Text(
                        "Aprobado",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 24,
                        ),
                      )
                    : Text(
                        "Desaprobado",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                        ),
                      )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Nota al $totalPercent%"),
                Text(
                  widget.course.score.toStringAsFixed(2),
                  style: TextStyle(fontSize: 32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget myAddButtons() {
    return ElevatedButton(
      onPressed: () async {
        await addEvaluation();
        setState(() {});
      },
      child: Text("Añadir evaluación"),
    );
  }

  Widget myDataTable() {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: DataTable(
        columnSpacing: 0,
        horizontalMargin: 0,
        headingRowHeight: 40,
        border: TableBorder.all(width: 1),
        columns: headers.map<DataColumn>((String header) {
          return DataColumn(
            label: Expanded(
              child: Text(
                header,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
        rows: evaluations.map<DataRow>((Evaluation evaluation) {
          var index = evaluations.indexOf(evaluation);
          return DataRow(
            color: MaterialStateProperty.resolveWith((states) {
              if (index.isEven) {
                return Colors.grey.shade300;
              }
              return null;
            }),
            cells: <DataCell>[
              DataCell(
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.38,
                  child: Text(
                    evaluation.name,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: Text(
                    "${evaluation.weight.toString()} %",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: Text(
                    evaluation.score!.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            await editEvaluation(evaluation);
                            setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await deleteEvaluation(evaluation);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
