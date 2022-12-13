// ignore_for_file: prefer_if_null_operators, prefer_null_aware_operators

import 'package:objectbox/objectbox.dart';
import 'package:u_calc/Cycle/model/cycle.dart';
import 'package:u_calc/Evaluation/model/evaluation.dart';

@Entity()
class Course {
  int id = 0;
  String name;
  int weigth;
  double score;

  final cycle = ToOne<Cycle>();

  @Backlink()
  final evaluations = ToMany<Evaluation>();

  Course({
    required this.name,
    required this.weigth,
    required this.score,
  });
}
