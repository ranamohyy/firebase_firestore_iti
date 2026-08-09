import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  ///=============object from firebase=============================
  final fireAuth = FirebaseAuth.instance;

  ///=================controllers======================
  TextEditingController emailRegisterControl = TextEditingController();
  TextEditingController passwordRegisterControl = TextEditingController();

  TextEditingController emailControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();

  ///==============signUp method======================

  Future<void> signUp() async {
    emit(RegisterLoading());
    try {
      await fireAuth.createUserWithEmailAndPassword(
        email: emailRegisterControl.text,
        password: passwordRegisterControl.text,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      emit(RegisterFailure(e.toString()));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }

  ///==============signUp method======================

  Future<void> signIn() async {
    emit(LoginLoading());
    try {
      await fireAuth.signInWithEmailAndPassword(
        email: emailControl.text,
        password: passwordControl.text,
      );

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(e.toString()));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    emailRegisterControl.dispose();
    passwordRegisterControl.dispose();
    emailControl.dispose();
    passwordControl.dispose();
    return super.close();
  }
}
