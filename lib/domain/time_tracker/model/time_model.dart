import 'package:flutter/material.dart';

class TimeModel {
  final String buildingSiteId;
  final String date;
  final String startEndTime;
  final int hours;
  final String id;
  final DateTime startTime;
  final DateTime stopTime;

  TimeModel(
      {required this.buildingSiteId,
      required this.date,
      required this.startEndTime,
      required this.hours,
      required this.id,
      required this.startTime,
      required this.stopTime});
}
