part of 'home_cubit.dart';


abstract class HomeState {}

final class HomeInitial extends HomeState {}
final class HomeLoading extends HomeState {}
final class HomeFailure extends HomeState {
 final String msg;
 HomeFailure(this.msg);
}


 class AddStudentSuccess extends HomeState {}


 class GetStudentSuccess extends HomeState {
  List<QueryDocumentSnapshot>students;
  GetStudentSuccess(this.students);

 }


