import 'package:building_site_tracker/domain/time_tracker/model/time_model.dart';

abstract class TimeTrackerRep {
  Future<void> startTimer({required String buildingSiteId});
  Future<void> stopTimer({required String buildingSiteId});

  Future<Duration> getCurrentTime({required String buildingSiteId});

  Future<List<TimeModel>> getHours({required String buildingSiteId});

  Future<void> deleteTime({required String id});

  Future<void> editTime(
      {required String id,
      required DateTime newStart,
      required DateTime newEnd});
}
