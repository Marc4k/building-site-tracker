import 'package:bloc/bloc.dart';
import 'package:building_site_tracker/domain/building_site/building_site_impl.dart';
import 'package:building_site_tracker/domain/time_tracker/model/time_model.dart';
import 'package:building_site_tracker/domain/time_tracker/time_tracker_impl.dart';

class GetTimeDataCubit extends Cubit<List<TimeModel>> {
  GetTimeDataCubit() : super([]);

  Future<void> getTimeData(String name) async =>
      emit(await TimeTrackerImpl().getHours(name: name));

  @override
  void onChange(Change<List<TimeModel>> change) {
    super.onChange(change);
  }
}
