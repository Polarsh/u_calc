// ignore_for_file: prefer_if_null_operators, prefer_null_aware_operators

import 'package:objectbox/objectbox.dart';
import 'package:u_calc/Course/model/course.dart';

@Entity()
class Cycle {
  int id = 0;
  String name;
  double score;

  @Backlink()
  final courses = ToMany<Course>();

  Cycle({
    required this.name,
    required this.score,
  });
}
