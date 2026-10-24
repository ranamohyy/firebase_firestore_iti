part of 'home_cubit.dart';


abstract class HomeState {}

final class HomeInitial extends HomeState {}
final class HomeLoading extends HomeState {}
final class HomeFailure extends HomeState {
 final String msg;
 HomeFailure(this.msg);
}

///------------           add collection -------------------------------
///---------------------edit-------------------
///----------------------get------------------------------------
///-------------------delete-------------------------------------

///-------------get success---------------------------
class GetStudentsSuccess extends HomeState{
 final List<QueryDocumentSnapshot<Map<String,dynamic>>>students;
 GetStudentsSuccess(this.students);
}
///---------------------add success-----------------------------
class AddStudentSuccess extends HomeState{}


///===================update success==========================
class UpdateStudentSuccess extends HomeState{}

///======================delete success=============================
class DeleteStudentSuccess extends HomeState{}