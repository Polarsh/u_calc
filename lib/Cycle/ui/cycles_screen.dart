// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:u_calc/Course/ui/courses_screen.dart';
import 'package:u_calc/Cycle/model/cycle.dart';
import 'package:u_calc/Cycle/ui/add_cycle_screen.dart';
import 'package:u_calc/Settings/settings_screen.dart';
import 'package:u_calc/objectbox.g.dart';

import '../../Course/model/course.dart';

class CyclesScreen extends StatefulWidget {
  const CyclesScreen({Key? key}) : super(key: key);

  @override
  State<CyclesScreen> createState() => _CyclesScreenState();
}

class _CyclesScreenState extends State<CyclesScreen> {
  final List<Cycle> cycles = [];

  late final Box<Cycle> cycleBox;
  late final Store store;

  @override
  void initState() {
    _loadStore();
    super.initState();
  }

  Future<void> addCycle() async {
    final result =
        await showDialog(context: context, builder: (_) => AddCycleScreen());

    if (result != null && result is Cycle) {
      cycleBox.put(result);
      _loadCycles();
    }
  }

  void _loadStore() async {
    store = await openStore();

    cycleBox = store.box<Cycle>();
    _loadCycles();
  }

  void _loadCycles() {
    cycles.clear();
    setState(() {
      cycles.addAll(cycleBox.getAll());
    });
  }

  Future<void> goToCourses(Cycle cycle) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return CoursesScreen(
            cycle: cycle,
            store: store,
          );
        },
      ),
    );

    _loadCycles();
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
        title: Text("Ciclos"),
        centerTitle: true,
      ),
      body: cycles.isEmpty
          ? Center(
              child: Text("Añade un ciclo académico para comenzar"),
            )
          : cycleItemList(context, cycles, store),
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
              await addCycle();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget cycleItemList(BuildContext context, List<Cycle> cycles, Store store) {
    return ListView.separated(
      itemCount: cycles.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox.shrink();
      },
      itemBuilder: (BuildContext context, int index) {
        return cycleItemCard(context, cycles[index], store);
      },
    );
  }

  Widget cycleItemCard(BuildContext context, Cycle cycle, Store store) {
    var selected = false;

    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,
      trailing: InkWell(
          onTap: () {
            goToCourses(cycle);
          },
          child: const Icon(Icons.keyboard_arrow_right)),
      onExpansionChanged: (value) {
        selected == !selected;
      },
      title: Text("Ciclo: ${cycle.name}"),
      subtitle: Text("Promedio: ${cycle.score.roundToDouble()}"),
      children: <Widget>[courseItemsList(cycle.courses)],
    );
  }

  Widget courseItemsList(List<Course> courses) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (BuildContext context, int index) {
        return courseItemCard(courses[index]);
      },
    );
  }

  Widget courseItemCard(Course course) {
    return ListTile(
      leading: const SizedBox(
        width: 30,
      ),
      title: Text("Curso: ${course.name}"),
      subtitle: Text("Nota: ${course.score.toStringAsFixed(2)}"),
    );
  }
}
