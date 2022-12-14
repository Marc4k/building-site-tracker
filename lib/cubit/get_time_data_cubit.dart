import 'package:bloc/bloc.dart';
import '../domain/building_site/building_site_impl.dart';
import '../domain/time_tracker/model/time_model.dart';
import '../domain/time_tracker/time_tracker_impl.dart';

class GetTimeDataCubit extends Cubit<List<TimeModel>> {
  GetTimeDataCubit() : super([]);

  Future<void> getTimeData(String buildingSiteId) async =>
      emit(await TimeTrackerImpl().getHours(buildingSiteId: buildingSiteId));

  @override
  void onChange(Change<List<TimeModel>> change) {
    super.onChange(change);
  }
}
