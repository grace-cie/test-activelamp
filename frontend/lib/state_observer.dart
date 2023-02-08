import 'package:bloc/bloc.dart';

class StateObserver extends BlocObserver {
  const StateObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}