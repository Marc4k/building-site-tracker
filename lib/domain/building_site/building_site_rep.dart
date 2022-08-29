import 'package:building_site_tracker/error/failures.dart';
import 'package:dartz/dartz.dart';

import 'model/building_site_model.dart';

abstract class BuildingSiteRep {
  Future<List<BuildingSiteModel>> getAlleBuildingSiteNames();

  Future<Either<String, Failure>> createNewBuildingSite({required String name});

  Future<void> deleteBuildingSite({required String buildingSiteId});
}
