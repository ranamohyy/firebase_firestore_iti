part of 'auth_cubit.dart';


abstract class AuthState {}

final class AuthInitial extends AuthState {}

///----------------register -------------------------

 class RegisterLoading extends AuthState {}

 class RegisterSuccess extends AuthState {}

 class RegisterFailure extends AuthState {
     final String msg;
     RegisterFailure(this.msg);
 }

///----------------login -------------------------

 class LoginLoading extends AuthState {}

 class LoginSuccess extends AuthState {}

 class LoginFailure extends AuthState {
     final String msg;
     LoginFailure(this.msg);
 }

 ///------------mail--------------
 class EmailNotVerified extends AuthState{}
class ResendVerifySuccess extends AuthState{}

class VerifyLoading extends AuthState{}
class VerifySuccess extends AuthState{}
class VerifyFailure extends AuthState{
  final String msg ;
  VerifyFailure(this.msg);
}
