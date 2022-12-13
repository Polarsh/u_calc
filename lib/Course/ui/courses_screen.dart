// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:u_calc/Course/model/course.dart';
import 'package:u_calc/Course/ui/add_course_screen.dart';
import 'package:u_calc/Cycle/model/cycle.dart';
import 'package:u_calc/Evaluation/ui/evaluations_screen.dart';
import 'package:u_calc/objectbox.g.dart';

class CoursesScreen extends StatefulWidget {
  final Cycle cycle;
  final Store store;
  const CoursesScreen({Key? key, required this.cycle, required this.store})
      : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<Course> courses = [];

  @override
  void initState() {
    courses.addAll(List.from(widget.cycle.courses));
    super.initState();
  }

  Future<void> addCourse() async {
    final result =
        await showDialog(context: context, builder: (_) => AddCourseScreen());

    if (result != null && result is Course) {
      result.cycle.target = widget.cycle;
      widget.store.box<Course>().put(result);
      _reloadCourses();
    }
  }

  void _reloadCourses() {
    courses.clear();

    QueryBuilder<Course> builder = widget.store.box<Course>().query();
    builder.link(Course_.cycle, Cycle_.id.equals(widget.cycle.id));
    Query<Course> query = builder.build();
    List<Course> coursesResult = query.find();
    setState(() {
      courses.addAll(coursesResult);
    });
    query.close();
  }

  Future<void> goToEvaluations(Course course) async {
    Navigator.of(context).push(
      await MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return EvaluationsScreen(
            course: course,
            store: widget.store,
          );
        },
      ),
    );

    _reloadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cursos"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CycleInfo(context, widget.cycle),
          Divider(),
          Expanded(
            child: isEmpty(context, courses, widget.store),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addCourse();
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget CycleInfo(BuildContext context, Cycle cycle) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: ListTile(
        title: Text("Ciclo: ${cycle.name}"),
        subtitle: Text("Promedio: ${cycle.score}"),
      ),
    );
  }

  Widget isEmpty(BuildContext context, List<Course> courses, Store store) {
    return courses.isEmpty
        ? Center(
            child: Text("No se han añadido curso. Añadelos!"),
          )
        : coursesItemList(context, courses, store);
  }

  Widget coursesItemList(
      BuildContext context, List<Course> courses, Store store) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: courses.length,
      itemBuilder: (BuildContext context, int index) {
        return courseItemCard(context, courses[index], store);
      },
    );
  }

  Widget courseItemCard(BuildContext context, Course course, Store store) {
    return GestureDetector(
      onTap: () {
        goToEvaluations(course);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Nombre: ${course.name}"),
            Text("Nota: ${course.score.toString()}"),
            Text("Créditos: ${course.weigth.toString()}"),
          ],
        ),
      ),
    );
  }
}
