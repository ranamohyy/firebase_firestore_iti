import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  ///==============instance from firebase ===================
  final fireAuth = FirebaseAuth.instance;

  ///----------controllers register----------------------------------
  TextEditingController emailRegisterControl = TextEditingController();
  TextEditingController passwordRegisterControl = TextEditingController();

  ///----------controllers login----------------------------------
  TextEditingController emailLoginControl = TextEditingController();
  TextEditingController passwordLoginControl = TextEditingController();

  ///---------------sign up --------------

  Future<void> signUp() async {
    emit(RegisterLoading());

    try {
      final credential = await fireAuth.createUserWithEmailAndPassword(
        email: emailRegisterControl.text,
        password: passwordRegisterControl.text,
      );

      ///---------check if you have created an user------------------------
      final user = credential.user;

      if (user == null) {
        emit(RegisterFailure("Unable to create account"));
        return;
      }

      ///--------------------call send email verification method----------------------
      await user.sendEmailVerification();
      emit(RegisterSuccess());
    }
    ///----------handle error----------------------------------------------
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure('The account already exists for that email.'));
      }
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }

  ///-------------signIn----------------
  Future<void> login() async {
    emit(LoginLoading());

    try {
      final loginData = await fireAuth.signInWithEmailAndPassword(
        email: emailLoginControl.text,
        password: passwordLoginControl.text,
      );

      ///-------check  if there an user--------------------
      final user = loginData.user;
      if (user == null) {
        emit(LoginFailure("Unable to login"));
        return;
      }
      ///----------refresh-----------------------------------
      await user.reload();
      final updatedData = fireAuth.currentUser;

      if (updatedData != null && updatedData.emailVerified) {
        emit(LoginSuccess());
      } else {
        emit(EmailNoVerified());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure('Wrong password provided for that user.'));
      } else if (e.code == 'invalid-credential') {
        emit(LoginFailure('No user found'));
      } else {
        emit(LoginFailure("fire auth error"));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
  ///------------------resend verfy mail-----------

  Future<void> resendVerifyMail() async {
    emit(EmailLoadingVerify());
    try {
      final user = fireAuth.currentUser;

      if (user == null) {
        emit(VerifyFailure("please sign in to continue "));
        return;
      }

      ///----------refresh-----------------------------------
      await user.reload();
      final updatedData = fireAuth.currentUser;
      if (updatedData == null) {
        emit(VerifyFailure("please sign in to continue "));
        return;
      }
      if (updatedData.emailVerified) {
        emit(VerifySuccess());
        return;
      }

      await updatedData.sendEmailVerification();
      emit(ResendVerifySuccess());
    } on FirebaseAuthException catch (e) {
      emit(VerifyFailure(e.code));
    } catch (e) {
      emit(VerifyFailure(e.toString()));
    }
  }


}
