import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  ///===========object=========================
  final cloud = FirebaseFirestore.instance;

  ///===================collection name =========================
  final String collectionName = 'students';

  ///==================controllers============================

  final nameControl = TextEditingController();
  final ageControl = TextEditingController();
  final gradeControl = TextEditingController();

  ///=============add students ==========================

  Future<void> addStudentToServer() async {
    emit(HomeLoading());
    try {
      await cloud.collection(collectionName).add({
        'name': nameControl.text,
        'age': ageControl.text,
        'grade': gradeControl.text,
      });

      emit(AddStudentSuccess());
    }
    ///----------handle errors--------------
    catch (E) {
      emit(HomeFailure(E.toString()));
    }
  }

  ///===============get students from server===============================

  Future<void> getStudentsFromServer() async {
    emit(HomeLoading());
    try {
      final response = await cloud.collection(collectionName).get();
      emit(GetStudentSuccess(response.docs));
    }
    ///-------handle errors--------------
    catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  ///===========delete=====================================
  Future<void> deleteStudents(String id) async {
    try {
      await cloud.collection(collectionName).doc(id).delete();
      emit(DeleteStudentSuccess());
    }
    ///------------handle error--------------------
    catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  ///===================update==================================

  Future<void> updateStudent(String id) async {
    try {
      await cloud.collection(collectionName).doc(id).update({
        'name': nameControl.text,
        'age': ageControl.text,
        'grade': gradeControl.text,
      });
      emit(UpdateStudentSuccess());
    }
    ///-------handle errors---------------
    catch (E) {
      emit(HomeFailure(E.toString()));
    }
  }

  ///==============================close==============

  @override
  Future<void> close() {
    nameControl.dispose();
    ageControl.dispose();
    gradeControl.dispose();
    return super.close();
  }
}
