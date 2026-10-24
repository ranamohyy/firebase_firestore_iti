import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_system_iti/home/controller/home_cubit.dart';

import '../widgets/home_content.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => HomeCubit()..getStudentsFromServer()
        , child: HomeContent());
  }
}
