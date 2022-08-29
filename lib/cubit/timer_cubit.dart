import 'dart:async';

import 'package:bloc/bloc.dart';
import '../domain/user_authentication/user_authentication_impl.dart';

import '../domain/time_tracker/time_tracker_impl.dart';

class TimerCubit extends Cubit<Duration> {
  TimerCubit() : super(Duration(days: 187));
  Timer? timer;

  void setTimer(Duration newDuration) {
    Duration duration = newDuration;

    emit(duration);
  }

  void startTimer() {
    Duration duration = Duration();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      final seconds = state.inSeconds + 1;
      duration = Duration(seconds: seconds);

      emit(duration);
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  Future<void> getCurrentTimeC(String buildingSiteId) async {
    Duration newDuration =
        await TimeTrackerImpl().getCurrentTime(buildingSiteId: buildingSiteId);

    if (newDuration.inSeconds != 0 && newDuration.inDays != 99) {
      startTimer();
    }

    emit(newDuration);
  }

  @override
  void onChange(Change<Duration> change) {
    super.onChange(change);
  }
}
