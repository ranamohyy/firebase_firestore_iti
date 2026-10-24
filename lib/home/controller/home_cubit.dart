import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  ///===========object=========================
  final cloud = FirebaseFirestore.instance;

  ///===================doc name =========================
  final String docName = 'students';

  ///==================controllers============================
  final nameControl = TextEditingController();
  final ageControl = TextEditingController();
  final gradeControl = TextEditingController();

  ///=============add students ==========================
  Future<void> addStudentsToServer() async {
    emit(HomeLoading());

    try {
      await cloud.collection(docName).add({
        "name": nameControl.text.trim(),
        "age": ageControl.text.trim(),
        "grade": gradeControl.text.trim(),
      });

      ///-----------------------------------
      emit(AddStudentSuccess());
    }
    ///-------------------------handle errors---------------
    catch (E) {
      emit(HomeFailure(E.toString()));
    }
  }

  ///===============get students from server===============================
  Future<void> getStudentsFromServer() async {
    emit(HomeLoading());
    try {
      final response = await cloud.collection(docName).get();
      emit(GetStudentsSuccess(response.docs));
    }
    ///---------------handle errors-------------------------------
    catch (E) {
      emit(HomeFailure(E.toString()));
    }
  }

  ///===========delete=====================================

  Future<void> deleteStudent(String id) async {
    emit(HomeLoading());
    try {
      await cloud.collection(docName).doc(id).delete();
      emit(DeleteStudentSuccess());
    } catch (E) {
      emit(HomeFailure(E.toString()));
    }
  }

  ///===================update==================================
  Future<void> updateStudent(String id) async {
    emit(HomeLoading());
    try {
      await cloud.collection(docName).doc(id).update({
        'name': nameControl.text.trim(),
        'age': ageControl.text.trim(),
        'grade': gradeControl.text.trim(),
      });
      emit(UpdateStudentSuccess());
    } catch (E) {
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
