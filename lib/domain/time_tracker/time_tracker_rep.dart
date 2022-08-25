abstract class TimeTrackerRep {
  Future<void> startTimer({required String name});
  Future<void> stopTimer({required String name});

  Future<Duration> getCurrentTime({required String name});
}
