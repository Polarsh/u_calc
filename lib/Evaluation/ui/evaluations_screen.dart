// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:u_calc/Course/model/course.dart';
import 'package:u_calc/Evaluation/model/evaluation.dart';
import 'package:u_calc/Evaluation/ui/add_evaluation_screen.dart';
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

  Future<void> addEvaluation() async {
    final result = await showDialog(
        context: context, builder: (_) => AddEvaluationScreen());

    if (result != null && result is Evaluation) {
      result.course.target = widget.course;
      widget.store.box<Evaluation>().put(result);
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
          SpeedDialChild(child: Icon(Icons.edit), label: "Editar"),
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
    return Text("data");
  }

  Widget myDataTable() {
    return Center(
      child: DataTable(
        border: TableBorder.all(),
        columns: <DataColumn>[
          DataColumn(label: Text("Evaluación")),
          DataColumn(label: Text("Peso")),
          DataColumn(label: Text("Nota")),
        ],
        rows: evaluations.map<DataRow>((Evaluation evaluation) {
          return DataRow(
            cells: <DataCell>[
              DataCell(Text(evaluation.name)),
              DataCell(Text("${evaluation.weight.toString()} %")),
              DataCell(Text(evaluation.score!.toString())),
            ],
          );
        }).toList(),
      ),
    );
  }
}
