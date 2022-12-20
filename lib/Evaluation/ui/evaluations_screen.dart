// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:u_calc/Course/model/course.dart';
import 'package:u_calc/Evaluation/model/evaluation.dart';
import 'package:u_calc/Evaluation/ui/add_evaluation_screen.dart';
import 'package:u_calc/Evaluation/ui/edit_evaluation_screen.dart';
import 'package:u_calc/Settings/settings_screen.dart';
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
  List<Evaluation> evaluations = [];

  @override
  void initState() {
    evaluations.addAll(List.from(widget.course.evaluations));
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
    widget.store.box<Evaluation>().remove(evaluation.id);
    _reloadEvaluations();
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
  }

  void _goToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return SettingsScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Evaluaciones"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            myTitleCourse(),
            myDataTable(),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        spacing: 10,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            child: Icon(Icons.settings),
            label: "Ajustes",
            onTap: () {
              _goToSettings();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.edit),
            label: "Editar",
            onTap: () {},
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            label: "Añadir",
            onTap: () async {
              await addEvaluation();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget myTitleCourse() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width,
      color: Colors.blue.shade400,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text("Curso: ${widget.course.name}"),
                Text("Créditos: ${widget.course.weigth}"),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: Column(
              children: [
                Text("Nota acumulada: ${widget.course.score}"),
                Text("Nota al 20%"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget myDataTable() {
    return Center(
      child: DataTable(
        horizontalMargin: 10,
        columnSpacing: 20,
        headingRowHeight: 30,
        border: TableBorder.all(),
        columns: <DataColumn>[
          DataColumn(
            label: Text("Evaluación"),
          ),
          DataColumn(
            label: Text("Peso"),
          ),
          DataColumn(
            label: Text("Nota"),
          ),
          DataColumn(
            label: Text("Opciones"),
          ),
        ],
        rows: evaluations.map<DataRow>((Evaluation evaluation) {
          return DataRow(
            cells: <DataCell>[
              DataCell(Text(evaluation.name)),
              DataCell(Text("${evaluation.weight.toString()} %")),
              DataCell(Text(evaluation.score!.toString())),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await editEvaluation(evaluation);
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await deleteEvaluation(evaluation);
                      setState(() {});
                    },
                  ),
                ],
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}
