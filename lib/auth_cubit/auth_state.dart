part of 'auth_cubit.dart';


abstract class AuthState {}

final class AuthInitial extends AuthState {}

///===========login===================
 class LoginLoading extends AuthState {}
 class LoginSuccess extends AuthState {}
 class LoginFailure extends AuthState {
 final String msg;
 LoginFailure(this.msg);
 }
///===========Register===================
 class RegisterLoading extends AuthState {}
 class RegisterSuccess extends AuthState {}
 class RegisterFailure extends AuthState {
  final String msg;
  RegisterFailure(this.msg);
 }
 ///-------------email verify----------------------
class EmailNoVerified extends AuthState{}
class EmailLoadingVerify extends AuthState{}
class VerifySuccess extends AuthState{}
class ResendVerifySuccess extends AuthState{}
class VerifyFailure extends AuthState{
 final String msg;
 VerifyFailure(this.msg);

}
