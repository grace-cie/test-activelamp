import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/urlshort/cubit/cubit.dart';
import 'package:frontend/urlshort/pages/mainscreen.dart';

class HomeToPage extends StatelessWidget {
  const HomeToPage({super.key});
  

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => UrlCubit(),
      child: const Homepage(),
    );
  }
}