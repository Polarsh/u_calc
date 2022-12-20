// ignore_for_file: prefer_if_null_operators, prefer_null_aware_operators

import 'package:objectbox/objectbox.dart';
import 'package:u_calc/Course/model/course.dart';

@Entity()
class Evaluation {
  int id = 0;
  String name;
  double weight;
  double? score;

  final course = ToOne<Course>();

  Evaluation({
    required this.name,
    required this.weight,
    this.score,
  });
}
