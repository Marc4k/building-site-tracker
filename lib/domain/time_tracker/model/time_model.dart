import 'package:flutter/material.dart';

class TimeModel {
  final String buildingSiteId;
  final String date;
  final String startEndTime;
  final double hours;
  final String id;
  final DateTime startTime;
  final DateTime stopTime;
  final String message;

  TimeModel(
      {required this.buildingSiteId,
      required this.message,
      required this.date,
      required this.startEndTime,
      required this.hours,
      required this.id,
      required this.startTime,
      required this.stopTime});
}
