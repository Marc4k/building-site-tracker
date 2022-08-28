import 'package:flutter/material.dart';

class TimeModel {
  final String buildingSiteId;
  final String date;
  final String startEndTime;
  final int hours;

  TimeModel({
    required this.buildingSiteId,
    required this.date,
    required this.startEndTime,
    required this.hours,
  });
}
