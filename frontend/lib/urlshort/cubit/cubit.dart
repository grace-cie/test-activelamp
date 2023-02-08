

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

class UrlCubit extends Cubit<String>{
  UrlCubit() : super('');

  void orig(String value) => emit(value);

  void short(String value) => emit(value);


}