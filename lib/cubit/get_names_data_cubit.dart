import 'package:bloc/bloc.dart';
import '../domain/user_authentication/user_authentication_impl.dart';

class GetNamesDataCubit extends Cubit<List<String>> {
  GetNamesDataCubit() : super([]);

  Future<void> getNames() async =>
      emit(await UserAuthenticationImpl().getAllNames());

  @override
  void onChange(Change<List<String>> change) {
    super.onChange(change);
  }
}
