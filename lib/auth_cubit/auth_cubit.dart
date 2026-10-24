import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  ///-------------------instance from firebase--------------------
  final fireAuth = FirebaseAuth.instance;

  ///-----------------controllers-------------------------------
  TextEditingController emailRegisterControl = TextEditingController();
  TextEditingController passwordRegisterControl = TextEditingController();

  ///-----------------------------------------------------------
  TextEditingController emailLoginControl = TextEditingController();
  TextEditingController passwordLoginControl = TextEditingController();

  ///-------------signup --> verify --> login
  ///-------------verify ,, create --> success
  ///------------- not verified --> screen verify account

  ///----------------sign up ---------------------------
  Future<void> signUp() async {
    emit(RegisterLoading());

    try {
      ///----------------request----------------
    final data=  await fireAuth.createUserWithEmailAndPassword(
        email: emailRegisterControl.text,
        password: passwordRegisterControl.text,
      );


    ///--------check------------
    final user = data.user;
    if(user == null){
      emit(RegisterFailure("UNABLE TO CREATE AN ACCOUT"));
     return;
    }
    ///---------------------call method to send verification------------
   await user.sendEmailVerification();


      emit(RegisterSuccess());
    }
    ///---------------handle error-------------------------
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure('The account already exists for that email.'));
      } else {
        emit(RegisterFailure("fireAuth exp"));
      }
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }

  ///--------------login----------------------
  Future<void> login() async {
    emit(LoginLoading());
    try {
      ///--------------------request-------------------------------------
    final data =  await fireAuth.signInWithEmailAndPassword(
        email: emailLoginControl.text,
        password: passwordLoginControl.text,
      );

    ///--------------check if there is an user ------------------------
    final user= data.user;
    if(user==null){
      emit(LoginFailure("Unable to login"));
      return;
    }
    ///------------------refresh ---------------------------
    await user.reload();
    ///--------get user from server ------------------------
    final updatedUser = fireAuth.currentUser;
    ///---------check if there is an user  and email is verified ------------
    if(updatedUser!=null && updatedUser.emailVerified){
      emit(LoginSuccess());

    }else{
      emit(EmailNotVerified());
    }


    }
    // /--------handle errors---------------------------
    on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure('Wrong password provided for that user.'));
      }else if (e.code =="invalid-credential"){
        emit(LoginFailure("password or mail is incorrect"));
      }else{
        emit(LoginFailure("fire auth exception"));
      }
    } catch (E) {
      emit(LoginFailure(E.toString()));
    }
  }


  ///-----------resend mail verification ------------------------

Future<void>resendMailVerification()async{
    emit(VerifyLoading());
    try{

      final user = fireAuth.currentUser;
      if(user ==null){
        emit(VerifyFailure("Please sign in to continue"));
        return;
      }
///--------------------------------------------------------------
      await user.reload();
      final updatedUser = fireAuth.currentUser;
      if(updatedUser ==null){
        emit(VerifyFailure("no login data found"));
        return;
      }
      if(updatedUser.emailVerified){
        emit(VerifySuccess());
        return;
      }


      ///-----------send mail verification-----------
      await updatedUser.sendEmailVerification();
      emit(ResendVerifySuccess());

    }
    ///--------handle errors--------------------
    on FirebaseAuthException catch(e){
      emit(VerifyFailure(e.code));
    }
    catch(e){
      emit(VerifyFailure(e.toString()));
    }


}




}
