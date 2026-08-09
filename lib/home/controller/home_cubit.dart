import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  ///===========object=========================
  final cloud = FirebaseFirestore.instance;

  ///================================
  TextEditingController nameControl = TextEditingController();
  TextEditingController ageControl = TextEditingController();
  TextEditingController gradeControl = TextEditingController();

  ///=================================add student ==============================================
  Future<void> addStudentToServer() async {
    emit(HomeLoading());
    try {
      await cloud.collection('students').add({
        'name': nameControl.text,
        'age': ageControl.text,
        'grade': gradeControl.text,
      }).then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      emit(AddStudentSuccess());
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  ///=================================get student ==============================================

  Future<void> getStudentFromServer() async {
    emit(HomeLoading());
    try {
      final response = await cloud.collection('students').get();
      emit(GetStudentSuccess(response.docs));
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  ///==============================================================
  @override
  Future<void> close() {
    nameControl.dispose();
    ageControl.dispose();
    gradeControl.dispose();
    return super.close();
  }

}
