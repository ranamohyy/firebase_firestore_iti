import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_system_iti/auth_cubit/auth_cubit.dart';
import 'package:student_system_iti/home/home_view.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify Your Email")),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is VerifySuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeView()),
            );
          }

          if (state is ResendVerifySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  "Your email link is sent success please check your mail",
                ),
              ),
            );
          }

          if (state is VerifyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: Colors.red, content: Text(state.msg)),
            );
          }
        },
        builder: (context, state) {
          if (state is EmailLoadingVerify) {
            return Center(child: CircularProgressIndicator());
          }
          final cubit = BlocProvider.of<AuthCubit>(context);
          return Column(
            children: [
              Text("Verify Your Email Address"),
              ElevatedButton(
                onPressed: () {
                  cubit.resendVerifyMail();
                },
                child: Text("send email verify"),
              ),
            ],
          );
        },
      ),
    );
  }
}
