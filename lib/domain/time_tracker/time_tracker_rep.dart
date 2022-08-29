import 'package:building_site_tracker/domain/time_tracker/model/time_model.dart';

abstract class TimeTrackerRep {
  Future<void> startTimer({required String name});
  Future<void> stopTimer({required String name});

  Future<Duration> getCurrentTime({required String name});

  Future<List<TimeModel>> getHours({required String name});

  Future<void> deleteTime({required String id});

  Future<void> editTime(
      {required String id,
      required DateTime newStart,
      required DateTime newEnd});
}
