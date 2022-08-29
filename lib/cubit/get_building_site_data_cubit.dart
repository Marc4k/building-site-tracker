import 'package:bloc/bloc.dart';
import 'package:building_site_tracker/domain/building_site/building_site_impl.dart';
import 'package:building_site_tracker/domain/user_authentication/user_authentication_impl.dart';

import '../domain/building_site/model/building_site_model.dart';

class GetBuildingSiteDataCubit extends Cubit<List<BuildingSiteModel>> {
  GetBuildingSiteDataCubit() : super([]);

  Future<void> getNames() async =>
      emit(await BuildingSiteImpl().getAlleBuildingSiteNames());

  @override
  void onChange(Change<List<BuildingSiteModel>> change) {
    super.onChange(change);
  }
}
