import 'package:bloc/bloc.dart';
import 'package:building_site_tracker/domain/time_tracker/time_tracker_impl.dart';

class GetCurrentTimeCubit extends Cubit<Duration> {
  GetCurrentTimeCubit(this.name) : super(Duration());
  final String name;
  Future<void> getTime() async =>
      emit(await TimeTrackerImpl().getCurrentTime(name: name));

  @override
  void onChange(Change<Duration> change) {
    super.onChange(change);
  }
}
