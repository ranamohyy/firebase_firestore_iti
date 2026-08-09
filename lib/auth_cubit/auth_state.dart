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
