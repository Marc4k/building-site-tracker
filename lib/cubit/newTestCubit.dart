import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:building_site_tracker/domain/user_authentication/user_authentication_impl.dart';

class NewTestCubit extends Cubit<Duration> {
  NewTestCubit() : super(Duration(seconds: 0));
  Timer? timer;

  void addSecond() {
    final seconds = state.inSeconds + 1;
    Duration duration = Duration(seconds: seconds);

    emit(duration);
  }

  void setTimer(Duration newDuration) {
    Duration duration = newDuration;

    emit(duration);
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      final seconds = state.inSeconds + 1;
      Duration duration = Duration(seconds: seconds);
      emit(duration);
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  void onChange(Change<Duration> change) {
    super.onChange(change);
  }
}
