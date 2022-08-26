import 'package:bloc/bloc.dart';

class StartStopCubit extends Cubit<int> {
  StartStopCubit() : super(0);
//0 start active
//1 stop active

  void setStartActive() {
    emit(0);
  }

  void setStopActive() {
    emit(1);
  }

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
  }
}
