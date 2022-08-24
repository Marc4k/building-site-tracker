abstract class BuildingSiteRep {
  Future<List<String>> getAlleBuildingSiteNames();

  Future<void> createNewBuildingSite({required String name});
}
